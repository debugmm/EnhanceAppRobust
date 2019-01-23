//
//  SwizzleMethodManager.h
//  ExceptionCatchReporter
//
//  Created by wujungao on 2019/1/23.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SwizzleMethodManager : NSObject

@property(atomic,assign,readonly)BOOL enabledSwizzled;

#pragma mark - method
/**
 @brief swizzling instance method(all swizzled class will be swizzled some origin selector)
 */
-(void)swizzlingInstanceMethod;

/**
 @brief recover swizzled instance method(recover origin selector)
 */
-(void)recoverSwizzledInstanceMethod;

@end

NS_ASSUME_NONNULL_END
