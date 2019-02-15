//
//  ExceptionCatchManager.m
//  ExceptionCatchReporter
//
//  Created by wujungao on 2019/1/23.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import "ExceptionCatchManager.h"

#import "BSBacktraceLogger.h"

#import <TargetConditionals.h>

#import <mach/mach_init.h>
#import <mach/mach_port.h>
#import <mach/task.h>
#include <execinfo.h>

#if TARGET_OS_OSX
#import <ExceptionHandling/ExceptionHandling.h>
#endif

#import "EARHeader.h"

//define
#define CC_NSHandleEveryExceptionMask (NSLogUncaughtExceptionMask|NSHandleUncaughtExceptionMask|NSHandleUncaughtSystemExceptionMask|NSHandleUncaughtRuntimeErrorMask|NSHandleTopLevelExceptionMask|NSHandleOtherExceptionMask)

#define CC_MaxCallStackFrames (4096)

#define MachPortListenThreadName (@"listen.machportmessage.thread")

@interface ExceptionCatchManager()<NSPortDelegate>

@property(nonatomic,nullable,copy,readwrite)NSString *logFilesDirectoryPath;

@property(nonatomic,nullable,strong)NSThread *machPortThread;//监听异常端口的线程

@end

@implementation ExceptionCatchManager

#pragma mark - life circle
+(ExceptionCatchManager *)sharedManager{
    
    static ExceptionCatchManager *ecm;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ecm=[[ExceptionCatchManager alloc] init];
    });
    
    return ecm;
}

-(instancetype)init{
    self=[super init];
    if(self){
        
    }
    
    return self;
}

#pragma mark - pub
#pragma mark - init config
-(void)initConfigExceptionCatch{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self configExceptionHandler];
        [self configSignalHandler];
        [self configMachCatchException];
    });
    
//    [self startMachPortThread];
}

#pragma mark -
-(void)catchException:(nullable NSException *)exception{
    
    NSString *content;
    if(exception==nil ||
       exception==NULL ||
       ![exception isKindOfClass:[NSException class]]){

        content=[BSBacktraceLogger bs_backtraceOfAllThread];
    }
    else{

        content=[self getFormatContentStringFromException:exception];
    }

    //write to file
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ExceptionCatchManager writeLogToFile:content];
//    });
}

#pragma mark - private
#pragma mark -
-(void)configExceptionHandler{
    
#if TARGET_OS_OSX
    [[NSExceptionHandler defaultExceptionHandler] setExceptionHandlingMask:NSLogAndHandleEveryExceptionMask];
    [[NSExceptionHandler defaultExceptionHandler] setDelegate:self];
#else
    NSSetUncaughtExceptionHandler(&myUnexceptionHandle);
#endif
}

-(void)configSignalHandler{
    
    struct sigaction newSignalAction;
    memset(&newSignalAction, 0,sizeof(newSignalAction));
    sigemptyset(&newSignalAction.sa_mask);
    newSignalAction.sa_flags=0;
    newSignalAction.sa_handler=&mySignalExceptionHandler;
    //    newSignalAction.sa_flags=SA_SIGINFO;//SA_NODEFER |
    //    newSignalAction.sa_sigaction=&mySignalExceptionHandler;
    //    newSignalAction.sa_handler = &mySignalExceptionHandler;
    
    sigaction(SIGHUP, &newSignalAction, NULL);
    sigaction(SIGINT, &newSignalAction, NULL);
    sigaction(SIGQUIT, &newSignalAction, NULL);
    sigaction(SIGABRT, &newSignalAction, NULL);
    sigaction(SIGILL, &newSignalAction, NULL);
    sigaction(SIGSEGV, &newSignalAction, NULL);
    
    sigaction(SIGFPE, &newSignalAction, NULL);
    sigaction(SIGBUS, &newSignalAction, NULL);
    sigaction(SIGPIPE, &newSignalAction, NULL);
}

#pragma mark -
-(void)startMachPortThread{
    
    [self.machPortThread start];
}

-(void)configMachCatchException{
    
    mach_port_t p=[self createPort];
    
    [self setMachPortExceptionPort:p];
    [self handleMachPort:p];
}

-(mach_port_t)createPort{
    
    mach_port_t server_port;
    
    kern_return_t kr=mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &server_port);
    assert(kr==KERN_SUCCESS);
    DLog(@"create a port:%d",server_port);
    
    return server_port;
}

-(void)setMachPortExceptionPort:(mach_port_t)mach_port{
    
    kern_return_t kr=mach_port_insert_right(mach_task_self(), mach_port, mach_port, MACH_MSG_TYPE_MAKE_SEND);
    assert(kr==KERN_SUCCESS);
    DLog(@"create a port:%d",mach_port);
    
    kr=task_set_exception_ports(mach_task_self(), EXC_MASK_BAD_ACCESS|EXC_MASK_CRASH|EXC_MASK_BAD_INSTRUCTION, mach_port, EXCEPTION_DEFAULT|MACH_EXCEPTION_CODES, THREAD_STATE_NONE);
    assert(kr==KERN_SUCCESS);
    DLog(@"create a port:%d",mach_port);
}


/**
 @brief 设置异常监听端口（添加到主线程中，因为初始化时运行在主线程，因此不需要特意在主线程执行此代码）

 @param mach_port 接收底层异常信号的端口
 @warning 当前多次测试，当主线程出现野指针崩溃问题时，端口无法收到消息
 需要考虑通过另外一个单独线程接收。
 而采用单独线程，同样无法收到异常消息，因此这个问题有待后续解决
 */
-(void)handleMachPort:(mach_port_t)mach_port{
    
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    NSPort *machport=[NSMachPort portWithMachPort:mach_port options:NSMachPortDeallocateSendRight | NSMachPortDeallocateReceiveRight];
    
    machport.delegate=self;
    [machport scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    //    });
}

#pragma mark - un-exception handle
#if TARGET_OS_IPHONE
void myUnexceptionHandle(NSException *exception){
    
    NSString *content;

    if(exception==nil ||
       exception==NULL ||
       ![exception isKindOfClass:[NSException class]]){

        content=[BSBacktraceLogger bs_backtraceOfAllThread];
    }
    else{

        NSString *name = [exception name];
        NSString *reason = [exception reason];

        NSArray *stackSymbols = [exception callStackSymbols];
        NSArray *stackAdds=[exception callStackReturnAddresses];

        content=[NSString stringWithFormat:@"Exception Name:%@\nException Reason:%@\nCallStackSymbols:%@\nCallStackReturnAddresses%@",name,reason,stackSymbols,stackAdds];
    }
    
    //write to file
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        [ExceptionCatchManager writeLogToFile:content];
//    });
}
#endif

#pragma mark - signal handle
void mySignalExceptionHandler(int signal){//(int signal, siginfo_t *siginfo, void *context){
    
    //    NSLog(@">>>>>:signal\n%@\n:<<<<<",[BSBacktraceLogger bs_backtraceOfAllThread]);
//    NSMutableString *mstr = [[NSMutableString alloc] init];
//    [mstr appendString:@"Stack:\n"];
//    void* callstack[1024];//128
//    int i, frames = backtrace(callstack, 1024);
//    char** strs = backtrace_symbols(callstack, frames);
//    for (i = 0; i <frames; ++i) {
//        [mstr appendFormat:@"%s\n", strs[i]];
//    }
    
    //write to file
    NSString *content=[BSBacktraceLogger bs_backtraceOfAllThread];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ExceptionCatchManager writeLogToFile:content];//[ExceptionCatchManager getFormatStackInfo]];
//    });
}

#pragma mark - mach port handler
-(void)handlePortMessage:(NSPortMessage *)message{
    
    NSString *content=[BSBacktraceLogger bs_backtraceOfAllThread];
    
    //write to file
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ExceptionCatchManager writeLogToFile:content];
//    });
}

#pragma mark - NSExceptionHandlerDelegate
//-(BOOL)exceptionHandler:(NSExceptionHandler *)sender
//     shouldLogException:(NSException *)exception
//                   mask:(NSUInteger)aMask{
//
//    return YES;
//}
#if TARGET_OS_OSX
-(BOOL)exceptionHandler:(NSExceptionHandler *)sender shouldHandleException:(NSException *)exception mask:(NSUInteger)aMask{
    
//    NSString *content;
//    if(exception==nil ||
//       exception==NULL ||
//       ![exception isKindOfClass:[NSException class]]){
//
//        content=[BSBacktraceLogger bs_backtraceOfAllThread];
//    }
//    else{
//
//        content=[self getFormatContentStringFromException:exception];
//    }
//
//    NSMutableString *mstr = [[NSMutableString alloc] init];
//    [mstr appendString:@"Stack:\n"];
//    void* callstack[1024];//128
//    int i, frames = backtrace(callstack, 1024);
//    char** strs = backtrace_symbols(callstack, frames);
//    for (i = 0; i <frames; ++i) {
//        [mstr appendFormat:@"%s\n", strs[i]];
//    }
    
    //write to file
    NSString *content=[ExceptionCatchManager getFormatStackInfo];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ExceptionCatchManager writeLogToFile:content];
//    });
    
    return YES;
}
#endif

#pragma mark -
-(nonnull NSString *)getFormatContentStringFromException:(nonnull NSException *)exception{
    
    if(exception==nil ||
       exception==NULL ||
       ![exception isKindOfClass:[NSException class]]){
        
        return @"";
    }
    
    NSString *name = [exception name];
    NSString *reason = [exception reason];
    
    NSArray *stackSymbols = [exception callStackSymbols];
    NSArray *stackAdds=[exception callStackReturnAddresses];
    
    NSDictionary *uf=exception.userInfo;
    
    NSString *content=[NSString stringWithFormat:@"Exception Name:%@\nException Reason:%@\nCallStackSymbols:%@\nCallStackReturnAddresses%@\nUserInfo:%@",name,reason,stackSymbols,stackAdds,uf];
    
    return content;
}

+(nonnull NSString *)getFormatStackInfo{
    
    NSMutableString *mstr = [[NSMutableString alloc] init];
    [mstr appendString:@"Stack:\n"];
    void* callstack[CC_MaxCallStackFrames];//128
    int i, frames = backtrace(callstack, CC_MaxCallStackFrames);
    char** strs = backtrace_symbols(callstack, frames);
    for (i = 0; i <frames; ++i) {
        [mstr appendFormat:@"%s\n", strs[i]];
    }
    
    return mstr;
}

#pragma mark - write log to file
+(void)writeLogToFile:(nonnull NSString *)content{
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSString *basePath=[ExceptionCatchManager sharedManager].logFilesDirectoryPath;
        
        NSString *dateString=[ExceptionCatchManager fileNameGenerator];
        
        NSString *fullPath=[ExceptionCatchManager generateLogFileFullPath:basePath fileName:dateString];
        
        BOOL result=[[NSFileManager defaultManager] createFileAtPath:fullPath contents:[content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        
        if(!result){
            DLog(@"write log to file failed--filepath:%@",fullPath);
        }
//    });
}

#pragma mark -
+(nonnull NSString *)generateLogFileFullPath:(nonnull NSString *)basePath fileName:(nonnull NSString *)fileName{
    
    NSString *fp=[NSString stringWithFormat:@"%@/%@",basePath,fileName];
    
    return fp;
}


/**
 @brief 日志文件base path（basePath末尾未包含/，因此在生成文件完整路径时，应该添加/即：basePath/filename）
 （完整路径basePath/fileName）

 @return basePath is string type
 */
+(nonnull NSString *)basePathOfLogFile{
    
    NSString *basePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *bid=[NSBundle mainBundle].bundleIdentifier;
    basePath=[NSString stringWithFormat:@"%@/%@/%@",basePath,bid,@"exceptionlogs"];
    
    BOOL isDir=NO;
    NSFileManager *df=[NSFileManager defaultManager];
    NSError *er=nil;
    if([df fileExistsAtPath:basePath isDirectory:&isDir]){
        if(!isDir){
            //is not dir
            [df removeItemAtPath:basePath error:&er];
            [df createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:&er];
        }
    }
    else{
        //not exsit
        [df createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:&er];
    }
    
    if(er!=nil){
        //if error,do something
        basePath=@"";
    }
    
    return basePath;//格式：basepath，末尾没有反斜杠/
}

/**
 @brief log file文件名生成
 @return log file name 日志文件名
 @discussion 文件名生成规程：prefix(macOS)_bundlename_version_dateString(yyy-mmm-dd-hh-mm-ss)_timeIntervalSinceReferenceDate String_exceptionLog.txt
 */
+(nonnull NSString *)fileNameGenerator{
    
    NSString *prefix=@"macOS";
    NSString *bdname=[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    if(bdname && [bdname isKindOfClass:[NSString class]]){
        bdname=[bdname stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    NSString *shortVersion=[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *dateStr=[ExceptionCatchManager convertDateToYMDHMSString:[NSDate date]];
    NSString *timeIntStr=[NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSinceReferenceDate];
    NSString *fileName=[NSString stringWithFormat:@"%@_%@_%@_%@_%@_exceptionLog.txt",prefix,bdname,shortVersion,dateStr,timeIntStr];
    
    return fileName;
}

#pragma mark -
+(nonnull NSString *)convertDateToYMDHMSString:(nonnull NSDate *)date{
    
    NSDateFormatter *format=[ExceptionCatchManager generateLocalDateFormatter];
    
    [format setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];//yyyy-MM-dd HH:mm:ss zzz
    
    NSString *dateString=[format stringFromDate:date];
    
    return dateString;
}

+(nonnull NSDateFormatter *)generateLocalDateFormatter{
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    format.locale=[NSLocale currentLocale];
    format.timeZone=[NSTimeZone localTimeZone];
    
    return format;
}

#pragma mark - property
-(NSString *)logFilesDirectoryPath{
    
    if(_logFilesDirectoryPath==nil ||
       _logFilesDirectoryPath==NULL ||
       ([_logFilesDirectoryPath isKindOfClass:[NSString class]] && _logFilesDirectoryPath.length<=0)){
        
        _logFilesDirectoryPath=[ExceptionCatchManager basePathOfLogFile];
    }
    
    return _logFilesDirectoryPath;
}

-(NSThread *)machPortThread{
    if(!_machPortThread){
        _machPortThread=[[NSThread alloc] initWithTarget:self selector:@selector(configMachCatchException) object:nil];
        _machPortThread.name=MachPortListenThreadName;
    }
    
    return _machPortThread;
}

@end
