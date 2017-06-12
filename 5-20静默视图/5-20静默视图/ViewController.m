//
//  ViewController.m
//  5-20静默视图
//
//  Created by wyman on 2017/5/20.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "UIView+WY.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *nullSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *isHideOther;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 个性化配置,当然这里也可以返回自定义view【最好维护个regist的全局单例keep这个block 这样就可以全工程用了】
    [self.view wy_configNullView:^UIView *(NullView *defaultNullView) {
       // 还是使用默认的空视图
        defaultNullView.desText = @"点我看看~";
        return defaultNullView;
//        UIView *bew = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 33, 44)];
//        bew.backgroundColor = [UIColor redColor];
//        return bew;
    }];
    // 空视图事件
    [self.view wy_nullViewAddTarget:self action:@selector(revert)];
}

- (void)revert {
    self.nullSwitch.on = NO;
    [self.view wy_hideNullView];
}

- (IBAction)switchNullView:(UISwitch *)sender {
    if (sender.isOn) {
        // 这里也可以自定义类似 css原理 这里修改自定义view是最高优先级的
        [self.view wy_showNullView:^UIView *(NullView *defaultNullView) {
            defaultNullView.frame = CGRectMake(0, 100, 22, 22);
            defaultNullView.backgroundColor = [UIColor redColor];
            return defaultNullView;
        } heightOffset:0];
    } else {
        sender.on = NO;
        [self.view wy_hideNullView];
    }
    
}

- (IBAction)switchLoadingView:(UISwitch *)sender {
    if (sender.isOn) {
        sender.enabled = NO;
        if (self.isHideOther.isOn) {
             [self.view wy_startLodingHideOtherView];
        } else {
             [self.view wy_startLoding];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view wy_stopLoding];
            sender.on = NO;
            sender.enabled = YES;
        });
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
