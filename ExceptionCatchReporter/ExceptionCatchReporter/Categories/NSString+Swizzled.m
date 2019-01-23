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
    
    [NSString exchangeClassInstanceMethod:[NSString class] originalSelector:@selector(characterAtIndex:) swizzledSelector:@selector(zz_characterAtIndex:)];
    
    [NSString exchangeClassInstanceMethod:[NSString class] originalSelector:@selector(getCharacters:range:) swizzledSelector:@selector(zz_getCharacters:range:)];
    
    [NSString exchangeClassInstanceMethod:[NSString class] originalSelector:@selector(rangeOfCharacterFromSet:options:range:) swizzledSelector:@selector(zz_rangeOfCharacterFromSet:options:range:)];
    
    [NSString exchangeClassInstanceMethod:[NSString class] originalSelector:@selector(rangeOfString:options:range:locale:) swizzledSelector:@selector(zz_rangeOfString:options:range:locale:)];
}

#pragma mark - swizzling method
-(unichar)zz_characterAtIndex:(NSUInteger)index{
    
    @try {
        [self zz_characterAtIndex:index];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

-(void)zz_getCharacters:(unichar *)buffer range:(NSRange)range{
    
    @try {
        [self zz_getCharacters:buffer range:range];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

- (NSRange)zz_rangeOfCharacterFromSet:(NSCharacterSet *)searchSet options:(NSStringCompareOptions)mask range:(NSRange)rangeOfReceiverToSearch{
    
    @try {
        [self zz_rangeOfCharacterFromSet:searchSet options:mask range:rangeOfReceiverToSearch];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

- (NSRange)zz_rangeOfString:(NSString *)searchString options:(NSStringCompareOptions)mask range:(NSRange)rangeOfReceiverToSearch locale:(NSLocale *)locale{
    
    @try {
        [self zz_rangeOfString:searchString options:mask range:rangeOfReceiverToSearch locale:locale];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

@end
