//
//  ViewController.m
//  WYCoreTextDemo
//
//  Created by sialice on 16/5/16.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "CTDisplayView.h"
#import "CoreTextData.h"
#import "CTFrameParser.h"
#import "CTFrameParserConfig.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 1.创建view
    CTDisplayView *diaplayView = [[CTDisplayView alloc]init];
    diaplayView.frame =  CGRectMake(200, 200, 188, 55);
    [self.view addSubview:diaplayView];
    
    // 2.设置配置
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    config.textColor = [UIColor redColor];
    config.width = diaplayView.frame.size.width;
    
    // 3.创建文本模型
    CoreTextData *data = [CTFrameParser parseContent:@" 按照以上原则，我们将`CTDisplayView`中的部分内容拆开。" config:config];
    
    // 4.根据模型设置view的内容和大小
    diaplayView.data = data;
    CGRect frame = diaplayView.frame;
    frame.size.height = data.height;
    diaplayView.frame = frame;
    diaplayView.backgroundColor = [UIColor yellowColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
