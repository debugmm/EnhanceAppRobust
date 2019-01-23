//
//  NSObject+Swizzled.h
//  ExceptionCatchReporter
//
//  Created by wujungao on 2019/1/22.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Swizzled)

#pragma mark - swizzle config
+(void)initConfigInstanceMethodSwizzle;

@end

NS_ASSUME_NONNULL_END
