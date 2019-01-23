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
-(void)initConfigInstanceMethodSwizzle{
    
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
    
}

@end
