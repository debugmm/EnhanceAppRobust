//
//  NSMutableArray+Swizzled.m
//  ExceptionCatchReporter
//
//  Created by wujungao on 2019/1/22.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import "NSMutableArray+Swizzled.h"
#import "NSObject+CCategory.h"

@implementation NSMutableArray (Swizzled)

#pragma mark - swizzle config
+(void)initConfigInstanceMethodSwizzle{
    
    [NSMutableArray exchangeClassInstanceMethod:[NSMutableArray class] originalSelector:@selector(addObject:) swizzledSelector:@selector(zz_addObject:)];
    
    [NSMutableArray exchangeClassInstanceMethod:[NSMutableArray class] originalSelector:@selector(insertObject:atIndex:) swizzledSelector:@selector(zz_insertObject:atIndex:)];
    
    [NSMutableArray exchangeClassInstanceMethod:[NSMutableArray class] originalSelector:@selector(insertObjects:atIndexes:) swizzledSelector:@selector(zz_insertObjects:atIndexes:)];
    
    [NSMutableArray exchangeClassInstanceMethod:[NSMutableArray class] originalSelector:@selector(removeObjectAtIndex:) swizzledSelector:@selector(zz_removeObjectAtIndex:)];
    
    [NSMutableArray exchangeClassInstanceMethod:[NSMutableArray class] originalSelector:@selector(removeObjectsAtIndexes:) swizzledSelector:@selector(zz_removeObjectsAtIndexes:)];
    
    [NSMutableArray exchangeClassInstanceMethod:[NSMutableArray class] originalSelector:@selector(removeObject:inRange:) swizzledSelector:@selector(zz_removeObject:inRange:)];
    
    [NSMutableArray exchangeClassInstanceMethod:[NSMutableArray class] originalSelector:@selector(removeObjectIdenticalTo:inRange:) swizzledSelector:@selector(zz_removeObjectIdenticalTo:inRange:)];
    
    [NSMutableArray exchangeClassInstanceMethod:[NSMutableArray class] originalSelector:@selector(replaceObjectAtIndex:withObject:) swizzledSelector:@selector(zz_replaceObjectAtIndex:withObject:)];
    
    [NSMutableArray exchangeClassInstanceMethod:[NSMutableArray class] originalSelector:@selector(replaceObjectsAtIndexes:withObjects:) swizzledSelector:@selector(zz_replaceObjectsAtIndexes:withObjects:)];
    
    [NSMutableArray exchangeClassInstanceMethod:[NSMutableArray class] originalSelector:@selector(setObject:atIndexedSubscript:) swizzledSelector:@selector(zz_setObject:atIndexedSubscript:)];
}

#pragma mark - swizzling method
-(void)zz_addObject:(id)anObject{
    
    @try {
        [self zz_addObject:anObject];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

- (void)zz_insertObject:(id)anObject atIndex:(NSUInteger)index{
    
    @try {
        [self zz_insertObject:anObject atIndex:index];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

-(void)zz_insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes{
    
    @try {
        [self zz_insertObjects:objects atIndexes:indexes];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

-(void)zz_removeObjectAtIndex:(NSUInteger)index{
    
    @try {
        [self zz_removeObjectAtIndex:index];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

-(void)zz_removeObjectsAtIndexes:(NSIndexSet *)indexes{
    
    @try {
        [self zz_removeObjectsAtIndexes:indexes];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

-(void)zz_removeObject:(id)anObject inRange:(NSRange)range{
    
    @try {
        [self zz_removeObject:anObject inRange:range];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

-(void)zz_removeObjectIdenticalTo:(id)anObject inRange:(NSRange)range{
    
    @try {
        [self zz_removeObjectIdenticalTo:anObject inRange:range];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

-(void)zz_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    
    @try {
        [self zz_replaceObjectAtIndex:index withObject:anObject];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

-(void)zz_replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects{
    
    @try {
        [self zz_replaceObjectsAtIndexes:indexes withObjects:objects];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

-(void)zz_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx{
    
    @try {
        [self zz_setObject:obj atIndexedSubscript:idx];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

@end
