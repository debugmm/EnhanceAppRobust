//
//  NSMutableString+Swizzled.m
//  ExceptionCatchReporter
//
//  Created by wujungao on 2019/1/23.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import "NSMutableString+Swizzled.h"

#import "NSObject+CCategory.h"

@implementation NSMutableString (Swizzled)

#pragma mark - swizzle config
+(void)initConfigInstanceMethodSwizzle{
    
    Class class = NSClassFromString(@"__NSCFString");
    
    if(class==nil ||
       class==NULL){
        return;
    }
    
//    [NSMutableString exchangeClassInstanceMethod:class originalSelector:@selector(appendString:) swizzledSelector:@selector(zz_appendString:)];
    
    [NSMutableString exchangeClassInstanceMethod:class originalSelector:@selector(insertString:atIndex:) swizzledSelector:@selector(zz_insertString:atIndex:)];
    
    [NSMutableString exchangeClassInstanceMethod:class originalSelector:@selector(deleteCharactersInRange:) swizzledSelector:@selector(zz_deleteCharactersInRange:)];
    
//    [NSMutableString exchangeClassInstanceMethod:class originalSelector:@selector(substringFromIndex:) swizzledSelector:@selector(zz_substringFromIndex:)];
    
//    [NSMutableString exchangeClassInstanceMethod:class originalSelector:@selector(substringToIndex:) swizzledSelector:@selector(zz_substringToIndex:)];
    
//    [NSMutableString exchangeClassInstanceMethod:class originalSelector:@selector(substringWithRange:) swizzledSelector:@selector(zz_substringWithRange:)];
    
//    [NSMutableString exchangeClassInstanceMethod:class originalSelector:@selector(rangeOfString:options:range:locale:) swizzledSelector:@selector(zz_rangeOfString:options:range:locale:)];
}

#pragma mark - swizzling method
-(void)zz_appendString:(NSString *)aString{
    
    @try {
        [self zz_appendString:aString];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

-(void)zz_insertString:(NSString *)aString atIndex:(NSUInteger)loc{
    
    @try {
        [self zz_insertString:aString atIndex:loc];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

-(void)zz_deleteCharactersInRange:(NSRange)range{
    
    @try {
        [self zz_deleteCharactersInRange:range];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

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
