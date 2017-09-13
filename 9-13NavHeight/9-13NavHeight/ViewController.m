//
//  ViewController.m
//  9-13NavHeight
//
//  Created by wyman on 2017/9/13.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "ViewController1.h"
#import "SimpleNavgationBar.h"
#import <objc/runtime.h>


@interface ViewController ()
@property (nonatomic, strong)  UISlider *slider ;
@end

@interface UINavigationBar (Flexible)

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"ViewController";
    self.view.backgroundColor = [UIColor grayColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(push)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIImageView *topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    [self.view addSubview:topImageView];
    topImageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 250);
    
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 150, 250, 33)];
    _slider = slider;
    [self.view addSubview:slider];
    [slider addTarget:self action:@selector(slid:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)slid:(UISlider *)slid {
//     self.navigationController.navigationBar.fn_translationY = 40*slid.value;
    self.sn_translationY = 40*slid.value;
}

- (void)push {
    ViewController1 *v = [ViewController1 new];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

//    self.sn_statusBarHidden = YES;
      self.sn_translationY = 40*self.slider.value;
    self.sn_navBarBackgroundColor = [UIColor redColor];
    self.sn_statusBarBackgroundColor = [UIColor orangeColor];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBar.fn_translationY = 0;
    [self sn_reset];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end



@implementation UINavigationBar (Flexible)



@end






