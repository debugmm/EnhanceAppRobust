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
-(void)catchException:(nonnull NSException *)exception;

@end

NS_ASSUME_NONNULL_END
