//
//  ViewController.m
//  ExceptionCatchReporter
//
//  Created by wujungao on 2019/1/22.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import "ViewController.h"

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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        @try {
            [[NSMutableArray arrayWithCapacity:1] insertObject:nil atIndex:0];
        } @catch (NSException *exception) {
            NSLog(@"exception:%@",exception);
        }
        
//        char *nullPrt=NULL;
//        nullPrt[0]=1;
    });
}

@end
