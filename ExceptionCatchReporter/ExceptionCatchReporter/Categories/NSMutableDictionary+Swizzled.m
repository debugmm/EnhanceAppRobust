//
//  NSMutableDictionary+Swizzled.m
//  ExceptionCatchReporter
//
//  Created by wujungao on 2019/1/23.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import "NSMutableDictionary+Swizzled.h"

#import "NSObject+CCategory.h"

@implementation NSMutableDictionary (Swizzled)

#pragma mark - swizzle config
+(void)initConfigInstanceMethodSwizzle{
    
    [NSMutableDictionary exchangeClassInstanceMethod:[NSMutableDictionary class] originalSelector:@selector(setObject:forKey:) swizzledSelector:@selector(zz_setObject:forKey:)];
    
    [NSMutableDictionary exchangeClassInstanceMethod:[NSMutableDictionary class] originalSelector:@selector(setObject:forKeyedSubscript:) swizzledSelector:@selector(zz_setObject:forKeyedSubscript:)];
    
    [NSMutableDictionary exchangeClassInstanceMethod:[NSMutableDictionary class] originalSelector:@selector(removeObjectForKey:) swizzledSelector:@selector(zz_removeObjectForKey:)];
}

#pragma mark - swizzling method
-(void)zz_setObject:(id)anObject forKey:(id<NSCopying>)aKey{
    
    @try {
        [self zz_setObject:anObject forKey:aKey];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

-(void)zz_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key{
    
    @try {
        [self zz_setObject:obj forKeyedSubscript:key];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

-(void)zz_removeObjectForKey:(id)aKey{
    
    @try {
        [self zz_removeObjectForKey:aKey];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}



@end
