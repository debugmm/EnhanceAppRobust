//
//  ViewController.m
//  EnhanceAppRobust-OSX
//
//  Created by wujungao on 2019/2/15.
//  Copyright © 2019 wujungao. All rights reserved.
//

#import "ViewController.h"

typedef struct Test
{
    int a;
    int b;
}Test;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)machPortExceptionAction:(NSButton *)sender {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        char *nullPrt=NULL;
        nullPrt[0]=1;
    });
}

- (IBAction)normalExceptionAction:(NSButton *)sender {
    
    [NSException raise:@"test" format:@"hh"];
}

- (IBAction)signalExceptionAction:(NSButton *)sender {
    
    Test *pTest = {1,2};
    free(pTest);//导致SIGABRT的错误，因为内存中根本就没有这个空间，哪来的free，就在栈中的对象而已
    pTest->a = 5;
}

@end
