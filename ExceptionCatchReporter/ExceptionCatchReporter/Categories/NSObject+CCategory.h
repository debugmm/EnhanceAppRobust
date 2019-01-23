//
//  NSObject+CCategory.h
//  ExceptionCatchReporter
//
//  Created by wujungao on 2019/1/22.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CCategory)

#pragma mark - report exception
/**
 @brief report app exception(just send app exception info to some-where)
 
 @param exception exception(app exception)
 */
+(void)reportException:(nonnull NSException *)exception;

#pragma mark - method swizzled

/**
 @brief exchange class instance method
 
 @param cls the class
 @param originalSelector the class instance's original selector(will be swizzed)
 @param swizzledSelector an instance's selector which will exchange with original selector.
 */
+(void)exchangeClassInstanceMethod:(Class)cls
                  originalSelector:(SEL)originalSelector
                  swizzledSelector:(SEL)swizzledSelector;

@end

NS_ASSUME_NONNULL_END
