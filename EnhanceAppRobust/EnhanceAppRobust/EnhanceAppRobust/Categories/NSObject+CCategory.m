//
//  NSObject+CCategory.m
//  ExceptionCatchReporter
//
//  Created by wujungao on 2019/1/22.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import "NSObject+CCategory.h"

#import "ExceptionCatchManager.h"
//#import "NotRecognizeSelectorManager.h"

#import <objc/runtime.h>

@implementation NSObject (CCategory)

#pragma mark - report exception
+(void)reportException:(nonnull NSException *)exception{
    //do reporting exception
    
    //因为已经通过unexception方式捕获了异常，因此此处不需要再次记录异常，否则将导致重复记录问题
//    [[ExceptionCatchManager sharedManager] catchException:exception];
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

#pragma mark - override
/*
 @brief 经过测试发现，macOS部分系统私有库重写了forwardingTargetForSelector方法，实现了私有库内部消息转发等功能。
 如果我们采用category再次重写此方法，将导致私有库功能问题，因此不宜通过重写此方法来方式app崩溃和记录消息。
 
 但是，因为doesNotRecognizeSelector方法会raises an NSInvalidArgumentException, and generates an error message.
 所以，当出现这个问题之后，我们已经通过Set un-exception handler拦击了异常消息。问题自然而然的被解决了。
 只是，这样的导致所谓效率问题（其实对于现代计算机而言，系统生成的异常消息浪费的计算机资源可以忽略不计）
 */

//-(id)forwardingTargetForSelector:(SEL)aSelector{
//
//    return [NotRecognizeSelectorManager sharedManager];
//}

@end
