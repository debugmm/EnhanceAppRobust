//
//  AppDelegate.m
//  EnhanceAppRobust-OSX
//
//  Created by wujungao on 2019/2/15.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import "AppDelegate.h"

#import "ExceptionCatchManager.h"
#import "SwizzleMethodManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self initConfig];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - app init config
-(void)initConfig{
    
    [self configExceptionCatch];
    [self configSizeeleMethodManager];
}

#pragma mark - config exception catch
-(void)configExceptionCatch{
    
    [[ExceptionCatchManager sharedManager] initConfigExceptionCatch];
}

-(void)configSizeeleMethodManager{
    
    [[SwizzleMethodManager sharedManager] swizzlingInstanceMethod];
}

@end
