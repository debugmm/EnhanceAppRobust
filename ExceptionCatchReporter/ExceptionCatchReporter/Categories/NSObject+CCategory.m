//
//  NSObject+CCategory.m
//  ExceptionCatchReporter
//
//  Created by wujungao on 2019/1/22.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import "NSObject+CCategory.h"

#import "ExceptionCatchManager.h"

#import <objc/runtime.h>

@implementation NSObject (CCategory)

#pragma mark - report exception
+(void)reportException:(nonnull NSException *)exception{
    //do reporting exception
    [[ExceptionCatchManager sharedManager] catchException:exception];
}

#pragma mark - method swizzled
+(void)exchangeClassInstanceMethod:(Class)cls
                  originalSelector:(SEL)originalSelector
                  swizzledSelector:(SEL)swizzledSelector{
    
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(cls,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
