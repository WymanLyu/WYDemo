//
//  ViewController.m
//  WYCustomNavigationBar
//
//  Created by wyman on 2017/2/5.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+WYCustomNavigationBar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
   
    // Do any additional setup after loading the view, typically from a nib.
    
    self.wy_navgationBar.titleLbl.text = @"测试测试";
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundColor:[UIColor brownColor]];
    [btn setTitle:@"关闭/开启全屏侧滑" forState:UIControlStateNormal];
    btn.frame = CGRectMake(10, 100, 164, 64);
    [btn addTarget:self action:@selector(bac) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bac {
     self.wy_fullScreenPopGestureEnabled = !self.wy_fullScreenPopGestureEnabled;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    
    // 这里延迟额原因是因为怕手点太快，动画结束时候又触发了push了。
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.navigationController.childViewControllers.count >= 2) {
            //        [self.navigationController popViewControllerAnimated:YES];
        } else {
            ViewController *vc = [ViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
    });

   
    
}

@end
