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

#pragma mark - life circle

/**
 @brief shared manager(it's singleton)

 @return ExceptionCatchManager type instance
 */
+(ExceptionCatchManager *)sharedManager;

#pragma mark - init config

/**
 @brief exception catch init config
 */
-(void)initConfigExceptionCatch;

@end

NS_ASSUME_NONNULL_END
