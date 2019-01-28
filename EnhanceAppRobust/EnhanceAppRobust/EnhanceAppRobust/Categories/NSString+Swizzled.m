//
//  NSString+Swizzled.m
//  ExceptionCatchReporter
//
//  Created by wujungao on 2019/1/23.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import "NSString+Swizzled.h"

#import "NSObject+CCategory.h"

@implementation NSString (Swizzled)

#pragma mark - swizzle config
+(void)initConfigInstanceMethodSwizzle{
    
    Class class = NSClassFromString(@"__NSCFConstantString");
    
    if(class==nil ||
       class==NULL){
        return;
    }
    [NSString exchangeClassInstanceMethod:class originalSelector:@selector(substringFromIndex:) swizzledSelector:@selector(zz_substringFromIndex:)];
    
    [NSString exchangeClassInstanceMethod:class originalSelector:@selector(substringToIndex:) swizzledSelector:@selector(zz_substringToIndex:)];
    
    [NSString exchangeClassInstanceMethod:class originalSelector:@selector(substringWithRange:) swizzledSelector:@selector(zz_substringWithRange:)];
    
    [NSString exchangeClassInstanceMethod:class originalSelector:@selector(rangeOfString:options:range:locale:) swizzledSelector:@selector(zz_rangeOfString:options:range:locale:)];
    
    
    class = NSClassFromString(@"NSTaggedPointerString");
    if(class==nil ||
       class==NULL){
        return;
    }
    [NSString exchangeClassInstanceMethod:class originalSelector:@selector(substringFromIndex:) swizzledSelector:@selector(zz_substringFromIndex:)];
    
    [NSString exchangeClassInstanceMethod:class originalSelector:@selector(substringToIndex:) swizzledSelector:@selector(zz_substringToIndex:)];
    
    [NSString exchangeClassInstanceMethod:class originalSelector:@selector(substringWithRange:) swizzledSelector:@selector(zz_substringWithRange:)];
    
    [NSString exchangeClassInstanceMethod:class originalSelector:@selector(rangeOfString:options:range:locale:) swizzledSelector:@selector(zz_rangeOfString:options:range:locale:)];
}

#pragma mark - swizzling method
-(NSString *)zz_substringFromIndex:(NSUInteger)from{
    
    NSString *str=nil;
    @try {
        str=[self zz_substringFromIndex:from];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
    
    return str;
}

-(NSString *)zz_substringToIndex:(NSUInteger)to{
    
    NSString *str=nil;
    @try {
        str=[self zz_substringToIndex:to];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
    
    return str;
}

-(NSString *)zz_substringWithRange:(NSRange)range{
    
    NSString *str=nil;
    @try {
        str=[self zz_substringWithRange:range];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
    
    return str;
}

-(NSRange)zz_rangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)rangeOfReceiverToSearch locale:(NSLocale *)locale{
    
    NSRange ran={NSNotFound, 0};
    
    @try {
        ran=[self zz_rangeOfString:searchString options:mask range:rangeOfReceiverToSearch locale:locale];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
    
    return ran;
}


@end
