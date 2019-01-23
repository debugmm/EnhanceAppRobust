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
    
    [NSMutableString exchangeClassInstanceMethod:[NSMutableString class] originalSelector:@selector(applyTransform:reverse:range:updatedRange:) swizzledSelector:@selector(zz_applyTransform:reverse:range:updatedRange:)];
    
    [NSMutableString exchangeClassInstanceMethod:[NSMutableString class] originalSelector:@selector(deleteCharactersInRange:) swizzledSelector:@selector(zz_deleteCharactersInRange:)];
    
    [NSMutableString exchangeClassInstanceMethod:[NSMutableString class] originalSelector:@selector(insertString:atIndex:) swizzledSelector:@selector(zz_insertString:atIndex:)];
    
    [NSMutableString exchangeClassInstanceMethod:[NSMutableString class] originalSelector:@selector(replaceCharactersInRange:withString:) swizzledSelector:@selector(zz_replaceCharactersInRange:withString:)];
    
    [NSMutableString exchangeClassInstanceMethod:[NSMutableString class] originalSelector:@selector(replaceOccurrencesOfString:withString:options:range:) swizzledSelector:@selector(zz_replaceOccurrencesOfString:withString:options:range:)];
    
    [NSMutableString exchangeClassInstanceMethod:[NSMutableString class] originalSelector:@selector(setString:) swizzledSelector:@selector(zz_setString:)];
}

#pragma mark - swizzling method
-(BOOL)zz_applyTransform:(NSStringTransform)transform reverse:(BOOL)reverse range:(NSRange)range updatedRange:(NSRangePointer)resultingRange{
    
    BOOL result=NO;
    
    @try {
        result=[self zz_applyTransform:transform reverse:reverse range:range updatedRange:resultingRange];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
    
    return result;
}

- (void)zz_deleteCharactersInRange:(NSRange)range{
    
    @try {
        [self zz_deleteCharactersInRange:range];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

- (void)zz_insertString:(NSString *)aString atIndex:(NSUInteger)loc{
    
    @try {
        [self zz_insertString:aString atIndex:loc];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

- (void)zz_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString{
    
    @try {
        [self zz_replaceCharactersInRange:range withString:aString];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

- (NSUInteger)zz_replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange{
    
    NSUInteger numberOfReplacementsMade=0;
    
    @try {
        [self zz_replaceOccurrencesOfString:target withString:replacement options:options range:searchRange];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
    
    return numberOfReplacementsMade;
}

- (void)zz_setString:(NSString *)aString{
    
    @try {
        [self zz_setString:aString];
    } @catch (NSException *exception) {
        [NSObject reportException:exception];
    }
}

@end
