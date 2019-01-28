//
//  ViewController.m
//  EnhanceAppRobust
//
//  Created by wujungao on 2019/1/28.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import "ViewController.h"

#import "SwizzledHeader.h"
#import "SwizzleMethodManager.h"

@interface ViewController()

- (IBAction)sendException:(NSButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}


#pragma mark - actions
- (IBAction)sendException:(NSButton *)sender {
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//        @try {
//            [[NSMutableArray arrayWithCapacity:1] insertObject:nil atIndex:0];
//        } @catch (NSException *exception) {
//            NSLog(@"exception:%@",exception);
//        }
//
//        //        char *nullPrt=NULL;
//        //        nullPrt[0]=1;
//    });
    
    id str=@1;

    NSInteger aa=[str length];
//    [[NSMutableArray arrayWithCapacity:1] insertObject:nil atIndex:0];
    
//    [[SwizzleMethodManager sharedManager] recoverSwizzledInstanceMethod];
}

@end
