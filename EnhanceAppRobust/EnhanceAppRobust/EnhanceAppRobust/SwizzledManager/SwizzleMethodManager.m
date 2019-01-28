//
//  SwizzleMethodManager.m
//  ExceptionCatchReporter
//
//  Created by wujungao on 2019/1/23.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import "SwizzleMethodManager.h"

#import "SwizzledHeader.h"

@interface SwizzleMethodManager()

@property(atomic,assign,readwrite)BOOL enabledSwizzled;

@end

@implementation SwizzleMethodManager

#pragma mark - life circle
+(SwizzleMethodManager *)sharedManager{
    
    static SwizzleMethodManager *sm;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sm=[[SwizzleMethodManager alloc] init];
    });
    
    return sm;
}

#pragma mark -
-(instancetype)init{
    self=[super init];
    if(self){
        _enabledSwizzled=NO;
    }
    
    return self;
}

#pragma mark - pub method
-(void)swizzlingInstanceMethod{
    
    if(!self.enabledSwizzled){
        [self _swizzlingInstanceMethod];
        self.enabledSwizzled=YES;
    }
}

-(void)recoverSwizzledInstanceMethod{
    
    if(self.enabledSwizzled){
        [self _recoverSwizzledInstanceMethod];
        self.enabledSwizzled=NO;
    }
}

#pragma mark - private
-(void)_swizzlingInstanceMethod{
    [self configSwizzlingInstanceMethod];
}

-(void)_recoverSwizzledInstanceMethod{
    [self configSwizzlingInstanceMethod];
}

#pragma mark -
-(void)configSwizzlingInstanceMethod{
    
    [NSArray initConfigInstanceMethodSwizzle];
    [NSMutableArray initConfigInstanceMethodSwizzle];
    [NSMutableDictionary initConfigInstanceMethodSwizzle];
    
//    [NSString initConfigInstanceMethodSwizzle];
//    [NSMutableString initConfigInstanceMethodSwizzle];
    
    [NSObject initConfigInstanceMethodSwizzle];
}

@end
