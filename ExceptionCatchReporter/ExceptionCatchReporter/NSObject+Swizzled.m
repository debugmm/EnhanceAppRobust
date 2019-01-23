//
//  NSObject+Swizzled.m
//  ExceptionCatchReporter
//
//  Created by wujungao on 2019/1/22.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import "NSObject+Swizzled.h"
#import "NSObject+CCategory.h"

@implementation NSObject (Swizzled)

#pragma mark - swizzle config
-(void)initConfigInstanceMethodSwizzle{
    
}

#pragma mark - swizzling method
-(id)zz_valueForUndefinedKey:(NSString *)key{
    
    id mobj=nil;
    @try {
        mobj=[self zz_valueForUndefinedKey:key];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
    
    return mobj;
}

@end
