//
//  ViewController.m
//  1-22bannerTest
//
//  Created by wyman on 2017/1/22.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import "ViewController.h"
#import "WYMagicBanner.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    WYMagicBanner *banner = [[WYMagicBanner alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
    banner.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:banner];
    
    
    NSArray *imgArray = @[@"http://o9kbeutq6.bkt.clouddn.com/image/ad/%E4%B8%BB%E9%A2%981.png",
                         @"http://o9kbeutq6.bkt.clouddn.com/image/ad/%E4%B8%BB%E9%A2%982.png",
                         @"http://o9kbeutq6.bkt.clouddn.com/image/ad/%E4%B8%BB%E9%A2%983.png",
                         @"http://o9kbeutq6.bkt.clouddn.com/image/ad/%E4%B8%BB%E9%A2%984.png"];
    banner.imageURLStringsGroup = imgArray;
    
    
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    testBtn.frame = CGRectMake(0, 365, 44, 44);
    [testBtn addTarget:self action:@selector(testBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
}

- (void)testBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
