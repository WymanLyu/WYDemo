//
//  LEDLoginViewController.m
//  LEDCalculator
//
//  Created by wyman on 2017/4/13.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "LEDLoginViewController.h"

@interface LEDLoginViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopLcs;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountTopLcs;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordTopLcs;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logBtnTopLcs;


@end

@implementation LEDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fitLayout];
    
}

- (void)fitLayout {
    self.logoTopLcs.constant = fitH(self.logoTopLcs.constant*2);
    self.accountTopLcs.constant = fitH(self.accountTopLcs.constant*2);
    self.passwordTopLcs.constant = fitH(self.passwordTopLcs.constant*2);
    self.logBtnTopLcs.constant = fitH(self.logBtnTopLcs.constant*2);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
