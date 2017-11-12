//
//  ViewController.m
//  11-9TestOverrideFunc
//
//  Created by wyman on 2017/11/9.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "Son.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Father *f = [Father new];
    Son *s = [Son new];
    [s eat];// 在实现里面知道这个eat是否被重写了。。。
    
    
}





@end
