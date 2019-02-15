//
//  ViewController.m
//  EnhanceAppRobust-iOS
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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)machPortExceptionAction:(UIButton *)sender {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        char *nullPrt=NULL;
        nullPrt[0]=1;
    });
}

- (IBAction)normalExceptionAction:(UIButton *)sender {
    
    [NSException raise:@"test" format:@"hh"];
}

- (IBAction)signalExceptionAction:(UIButton *)sender {
    
    Test *pTest = {1,2};
    free(pTest);//导致SIGABRT的错误，因为内存中根本就没有这个空间，哪来的free，就在栈中的对象而已
    pTest->a = 5;
}

@end
