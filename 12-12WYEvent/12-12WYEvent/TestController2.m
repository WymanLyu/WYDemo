//
//  TestController2.m
//  12-12WYEvent
//
//  Created by wyman on 2017/2/10.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import "TestController2.h"
#import "NSObject+WYEvent.h"
#import "CustomView2.h"

@interface TestController2 ()

@property (weak, nonatomic) IBOutlet CustomView2 *v;

@end

@implementation TestController2

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.v.vc = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)send111:(id)sender {
    NSString *notiName = @"send111";
    if ([(UISwitch *)sender isOn]) {
        NSDictionary *dit = [NSDictionary dictionaryWithObjectsAndKeys:@(8888),@"value", nil];
        [self wy_postNotificationName:notiName userInfo:dit finishHandle:^{
            NSLog(@"send111调用发送完毕");
        }];
    }
   
}

- (IBAction)send222:(id)sender {
    NSString *notiName = @"send222";
    if ([(UISwitch *)sender isOn]) {
         NSDictionary *dit = [NSDictionary dictionaryWithObjectsAndKeys:@(8888),@"value", nil];
        [[NSObject new] wy_postNotificationName:notiName userInfo:dit finishHandle:^{
            NSLog(@"send222调用发送完毕");
        }];
    }
}

- (IBAction)send333:(id)sender {
    NSString *notiName = @"send333";
    if ([(UISwitch *)sender isOn]) {
        [self wy_postNotificationName:notiName userInfo:nil finishHandle:^{
            NSLog(@"send333调用发送完毕");
        }];
    }
}



@end
