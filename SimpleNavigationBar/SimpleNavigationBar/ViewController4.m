//
//  ViewController4.m
//  SimpleNavigationBar
//
//  Created by wyman on 2017/9/14.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController4.h"
#import "SimpleNavgationBar.h"
#import "ViewController2.h"
#import "ViewController3.h"
#import "ViewController1.h"

@interface ViewController4 ()
@property (nonatomic, strong)  UISlider *slider ;
@end

@implementation ViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"ViewController4";
    self.view.backgroundColor = [UIColor greenColor];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 150, 250, 33)];
    _slider = slider;
    [self.view addSubview:slider];
    [slider addTarget:self action:@selector(slid:) forControlEvents:UIControlEventValueChanged];
    
    UIButton *btn = [UIButton new];
    [btn setTitle:@"原生push到透明" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click1) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn2 = [UIButton new];
    [btn2 setTitle:@"原生push到蓝色" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(click2) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn3 = [UIButton new];
    [btn3 setTitle:@"push到原生" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(click3) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:btn];
    [self.view addSubview:btn2];
    [self.view addSubview:btn3];
    
    btn.frame = CGRectMake(100, 220, 155, 66);
    btn2.frame = CGRectMake(100, 320, 155, 66);
    btn3.frame = CGRectMake(100, 420, 155, 66);
}

- (void)click3 {
    ViewController1 *v = [ViewController1 new];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)click1 {
    ViewController2 *v = [ViewController2 new];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)click2 {
    ViewController3 *v = [ViewController3 new];
    [self.navigationController pushViewController:v animated:YES];
}



- (void)slid:(UISlider *)slid {
    self.sn_translationY = 40*slid.value;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sn_translationY = 40*self.slider.value;
    self.sn_navBarBackgroundColor = [UIColor yellowColor];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self sn_reset];
}


@end
