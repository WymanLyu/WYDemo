//
//  ViewController1.m
//  9-13NavHeight
//
//  Created by wyman on 2017/9/13.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController1.h"
#import "SimpleNavgationBar.h"

@interface ViewController1 ()

@property (nonatomic, strong)  UISlider *slider ;

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ViewController1";
    self.view.backgroundColor = [UIColor greenColor];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 150, 250, 33)];
    _slider = slider;
    [self.view addSubview:slider];
    [slider addTarget:self action:@selector(slid:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)slid:(UISlider *)slid {
    //     self.navigationController.navigationBar.fn_translationY = 40*slid.value;
    self.sn_translationY = 40*slid.value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sn_navBarBackgroundColor = [UIColor blueColor];
//    self.sn_translationY = 40*self.slider.value;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self sn_reset];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
