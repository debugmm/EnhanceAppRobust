//
//  NSArray+Swizzled.m
//  ExceptionCatchReporter
//
//  Created by wujungao on 2019/1/22.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import "NSArray+Swizzled.h"
#import "NSObject+CCategory.h"

@implementation NSArray (Swizzled)

#pragma mark - swizzle config
-(void)initConfigInstanceMethodSwizzle{
    
}

#pragma mark - swizzling method
-(id)zz_objectAtIndex:(NSUInteger)index{
    
    id mobj=nil;
    @try {
        mobj=[self zz_objectAtIndex:index];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
    
    return mobj;
}

-(id)zz_objectAtIndexedSubscript:(NSUInteger)idx{
    
    id mobj=nil;
    @try {
        mobj=[self zz_objectAtIndexedSubscript:idx];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
    
    return mobj;
}

- (NSArray *)zz_objectsAtIndexes:(NSIndexSet *)indexes{
    
    NSArray *m=nil;
    @try {
        m=[self zz_objectsAtIndexes:indexes];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
    
    return m;
}

@end
