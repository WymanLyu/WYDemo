//
//  ViewController.m
//  9-16NavigationBar
//
//  Created by wyman on 2017/9/16.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "WYExtension.h"

#import "NSString+WYEasyObjEx.h"
#import "UINavigationBar+SimpleNavigationBar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor wy_randomColor];
//    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage wy_imageWithUIColor:[[UIColor wy_randomColor] colorWithAlphaComponent:0.3] andFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor wy_randomColor]];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
        view.backgroundColor = [UIColor wy_randomColor];
        [self.navigationController.navigationBar.subviews[0] addSubview:view];
        [self.navigationController.navigationBar bringSubviewToFront:view];
    });


    self.title = @"xxx";
    
    
    BOOL b = [@"setSn_alpha:" easyObjEx_setter_equalTo:@"setsn_alpha:"];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
//    BOOL b = [@"setAgc:" performSelector:@selector(easyObjEx_setter_equalTo:) withObject:@"setagc:"];
#pragma clang diagnostic pop
    
//    Class c=  NSClassFromString(@"int");
//    NSLog(@"%@", c);
//    if () {
//        <#statements#>
//    }
    
//    self.navigationController.navigationBar.sn_alpha = 20.0;
//    [self.navigationController.navigationBar setSn_alpha:20.0];
//    [self.navigationController.navigationBar performSelector:@selector(setsn_alpha:) withObject:@(20)];
    
//    NSLog(@"%f", self.navigationController.navigationBar.sn_alpha);
    
    
//    NSLog(@"%zd", b);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"---%@", self.navigationController.navigationBar.sn_ss);
    
    self.navigationController.navigationBar.sn_ss = @"xxxxshabi";
    NSLog(@"==-%@", self.navigationController.navigationBar.sn_ss);
    
    
    self.navigationController.navigationBar.sn_alpha = 20.0;
    self.navigationController.navigationBar.sn_backgroundColor = [UIColor redColor];
    NSLog(@"%f-%@", self.navigationController.navigationBar.sn_alpha, self.navigationController.navigationBar.sn_backgroundColor);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self.navigationController.navigationBar wy_logSubViews];
    

    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    ViewController *v = [ViewController new];
//    [self.navigationController pushViewController:v animated:YES];
//}





@end
