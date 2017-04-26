//
//  LEDCalcultViewController.m
//  LEDCalculator
//
//  Created by wyman on 2017/4/13.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "LEDCalcultViewController.h"

@interface LEDCalcultViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calcultBtnBottomLcs;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionBtnBottomLcs;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *longTopLcs;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightBottomLcs;

@end

@implementation LEDCalcultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fitLayout];
}

- (void)fitLayout {
    self.calcultBtnBottomLcs.constant = fitH(self.calcultBtnBottomLcs.constant*2);
    self.optionBtnBottomLcs.constant = fitH(self.calcultBtnBottomLcs.constant*2);
    self.longTopLcs.constant = fitH(self.calcultBtnBottomLcs.constant*2);
    self.heightBottomLcs.constant = fitH(self.calcultBtnBottomLcs.constant*2);
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
