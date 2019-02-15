//
//  ExceptionCatchManager.h
//  ExceptionCatchReporter
//
//  Created by wujungao on 2019/1/23.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExceptionCatchManager : NSObject

/**
 @brief shared manager(it's singleton)

 @return ExceptionCatchManager type instance
 */
+(ExceptionCatchManager *)sharedManager;

/**
 @brief exception catch init config
 */
-(void)initConfigExceptionCatch;

/**
 @brief catch exception(just receive an exception instace for report)

 @param exception an nonull exception obj
 */
-(void)catchException:(nullable NSException *)exception;

/**
 @brief 日志文件存放目录路径（此路径末尾未包含反斜杠/）
 */
@property(nonatomic,nullable,copy,readonly)NSString *logFilesDirectoryPath;

@end

NS_ASSUME_NONNULL_END
