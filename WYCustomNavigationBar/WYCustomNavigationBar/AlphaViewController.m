//
//  AlphaViewController.m
//  WYCustomNavigationBar
//
//  Created by wyman on 2017/2/6.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "AlphaViewController.h"
#import "UIViewController+WYCustomNavigationBar.h"

@interface AlphaViewController ()

@property (weak, nonatomic) IBOutlet UISlider *alphaSlide;

@end

@implementation AlphaViewController

+ (void)load {
    [WYCustomNavgationBarAppearance appearanceWithClass:NSClassFromString(@"CustomNavVc") customBar:^(UIViewController *currentVc) {
        
        // 这里可以对导航栏自定义，最好将模糊层隐藏了
        currentVc.wy_navgationBar.blurView.hidden = YES;
        currentVc.wy_navgationBar.backgroundColor = [UIColor redColor];
        
        // 这里也可以对导航栏完全自定义，最好将模糊层隐藏了
        UIView *customView = [UIView new];
        customView.backgroundColor = [UIColor brownColor];
        //        currentVc.wy_navgationBar = nil;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)alphaChange:(id)sender {
    
    self.wy_navgationBar.alpha = self.alphaSlide.value;
    
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
