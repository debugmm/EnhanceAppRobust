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

typedef struct Test
{
    int a;
    int b;
}Test;

@interface ViewController()

- (IBAction)sendException:(NSButton *)sender;
- (IBAction)unexceptionBtnAction:(NSButton *)sender;
- (IBAction)signalBtnAction:(NSButton *)sender;

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

//        @try {
//            [[NSMutableArray arrayWithCapacity:1] insertObject:nil atIndex:0];
//        } @catch (NSException *exception) {
//            NSLog(@"exception:%@",exception);
//        }

                char *nullPrt=NULL;
                nullPrt[0]=1;
    });
}

- (IBAction)unexceptionBtnAction:(NSButton *)sender {
    
    [[NSMutableArray arrayWithCapacity:1] insertObject:nil atIndex:0];
}

- (IBAction)signalBtnAction:(NSButton *)sender {
    
//    [self testSignal];
    id numbber=@1;
    
    if(((NSString *)numbber).length>0){
        NSLog(@"");
    }
}


#pragma mark -
-(void)testSignal{
    
    //1.信号量
    Test *pTest = {1,2};
    free(pTest);//导致SIGABRT的错误，因为内存中根本就没有这个空间，哪来的free，就在栈中的对象而已
    pTest->a = 5;
    
//    pthread_mach_thread_np
}

@end
