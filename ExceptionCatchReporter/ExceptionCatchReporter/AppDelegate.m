//
//  AppDelegate.m
//  ExceptionCatchReporter
//
//  Created by wujungao on 2019/1/22.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import "AppDelegate.h"

#import "ExceptionCatchManager.h"

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
}

#pragma mark - config exception catch
-(void)configExceptionCatch{
    
    [[ExceptionCatchManager sharedManager] initConfigExceptionCatch];
}

@end
