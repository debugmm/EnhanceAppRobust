//
//  NSMutableIndexSet+Swizzled.m
//  ExceptionCatchReporter
//
//  Created by wujungao on 2019/1/23.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import "NSMutableIndexSet+Swizzled.h"

#import "NSObject+CCategory.h"

@implementation NSMutableIndexSet (Swizzled)

#pragma mark - swizzle config
+(void)initConfigInstanceMethodSwizzle{
    
    [NSMutableIndexSet exchangeClassInstanceMethod:[NSMutableIndexSet class] originalSelector:@selector(addIndexesInRange:) swizzledSelector:@selector(zz_addIndexesInRange:)];
}

#pragma mark - swizzling method
-(void)zz_addIndexesInRange:(NSRange)range{
    
    @try {
        [self zz_addIndexesInRange:range];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

@end
