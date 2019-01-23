//
//  ExceptionCatchManager.m
//  ExceptionCatchReporter
//
//  Created by wujungao on 2019/1/23.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import "ExceptionCatchManager.h"

#import "BSBacktraceLogger.h"

#import <mach/mach_port.h>
#import <mach/task.h>

#import <ExceptionHandling/ExceptionHandling.h>

//define
#define CC_NSHandleEveryExceptionMask (NSLogUncaughtExceptionMask|NSHandleUncaughtExceptionMask|NSHandleUncaughtSystemExceptionMask|NSHandleUncaughtRuntimeErrorMask|NSHandleTopLevelExceptionMask|NSHandleOtherExceptionMask)

@interface ExceptionCatchManager()<NSPortDelegate>

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

#pragma mark - init config
-(void)initConfigExceptionCatch{
    
    [self configExceptionHandler];
    [self configSignalHandler];
    [self configMachCatchException];
}

#pragma mark -
-(void)configExceptionHandler{
    
    [[NSExceptionHandler defaultExceptionHandler] setExceptionHandlingMask:NSLogAndHandleEveryExceptionMask];
    [[NSExceptionHandler defaultExceptionHandler] setDelegate:self];
}

-(void)configSignalHandler{
    
    signal(SIGHUP, mySignalExceptionHandler);
    signal(SIGINT, mySignalExceptionHandler);
    signal(SIGQUIT, mySignalExceptionHandler);
    signal(SIGABRT, mySignalExceptionHandler);
    signal(SIGILL, mySignalExceptionHandler);
    signal(SIGSEGV, mySignalExceptionHandler);
    signal(SIGFPE, mySignalExceptionHandler);
    signal(SIGBUS, mySignalExceptionHandler);
    signal(SIGPIPE, mySignalExceptionHandler);
}

#pragma mark -
-(void)configMachCatchException{
    
    mach_port_t p=[self createPort];
    
    [self setMachPortExceptionPort:p];
    [self handleMachPort:p];
}

-(mach_port_t)createPort{
    
    mach_port_t server_port;
    
    kern_return_t kr=mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &server_port);
    assert(kr==KERN_SUCCESS);
    NSLog(@"create a port:%d",server_port);
    
    return server_port;
}

-(void)setMachPortExceptionPort:(mach_port_t)mach_port{
    
    kern_return_t kr=mach_port_insert_right(mach_task_self(), mach_port, mach_port, MACH_MSG_TYPE_MAKE_SEND);
    assert(kr==KERN_SUCCESS);
    NSLog(@"create a port:%d",mach_port);
    
    kr=task_set_exception_ports(mach_task_self(), EXC_MASK_BAD_ACCESS|EXC_MASK_CRASH|EXC_MASK_BAD_INSTRUCTION, mach_port, EXCEPTION_DEFAULT|MACH_EXCEPTION_CODES, THREAD_STATE_NONE);
    assert(kr==KERN_SUCCESS);
    NSLog(@"create a port:%d",mach_port);
}

-(void)handleMachPort:(mach_port_t)mach_port{
    
    NSPort *machport=[NSMachPort portWithMachPort:mach_port options:NSMachPortDeallocateSendRight | NSMachPortDeallocateReceiveRight];
    
    machport.delegate=self;
    [machport scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark - mach port handler
-(void)handlePortMessage:(NSPortMessage *)message{
    
    NSLog(@">>>>>:machport\n%@\n:<<<<<",[BSBacktraceLogger bs_backtraceOfAllThread]);
    
    [self writeLogToFile:[BSBacktraceLogger bs_backtraceOfAllThread]];
}

#pragma mark - NSExceptionHandlerDelegate
//-(BOOL)exceptionHandler:(NSExceptionHandler *)sender
//     shouldLogException:(NSException *)exception
//                   mask:(NSUInteger)aMask{
//
//    return YES;
//}

-(BOOL)exceptionHandler:(NSExceptionHandler *)sender shouldHandleException:(NSException *)exception mask:(NSUInteger)aMask{
    
    NSLog(@">>>>>:unexception\n%@\n:<<<<<",[BSBacktraceLogger bs_backtraceOfAllThread]);
    
    return YES;
}

#pragma mark - signal handle
void mySignalExceptionHandler(int signal){
    
    NSLog(@">>>>>:signal\n%@\n:<<<<<",[BSBacktraceLogger bs_backtraceOfAllThread]);
}

#pragma mark - write log to file
-(void)writeLogToFile:(nonnull NSString *)content{
    
    NSString *basePath=[NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *dateString=[NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSinceReferenceDate];
    
    NSString *fullPath=[NSString stringWithFormat:@"%@/%@",basePath,dateString];
    
    BOOL result=[[NSFileManager defaultManager] createFileAtPath:fullPath contents:[content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    
    if(!result){
        NSLog(@"write log to file failed--filepath:%@",fullPath);
    }
}

@end
