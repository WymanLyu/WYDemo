//
//  ViewController.m
//  11-12滚动数字
//
//  Created by wyman on 2017/11/12.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "ScorePickerView.h"
#import "ScoreRotateView.h"

@interface ViewController () <ScorePickerViewDelegate, ScoreRotateViewDelegate>

@property (nonatomic, strong) ScorePickerView *scorePickerView;

@property (nonatomic, strong) ScoreRotateView *scoreRotateView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.scorePickerView = [[ScorePickerView alloc] initWithFrame:CGRectMake(30, 200, ITEM_W*3+ITEM_EX*2, ITEM_H+ITEM_EX*2)];
    self.scorePickerView.delegate = self;
    [self.view addSubview:self.scorePickerView];
    [self.scorePickerView setScore:50];
    
    self.scoreRotateView = [[ScoreRotateView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-(524.0/2), [UIScreen mainScreen].bounds.size.height-(692.0/2), 524.0, 524.0)];
    self.scoreRotateView.backgroundColor = [UIColor lightGrayColor];
    self.scoreRotateView.delegate = self;
    [self.view addSubview:self.scoreRotateView];

}



- (void)scorePickerView:(ScorePickerView *)scoreView scoreChange:(NSInteger)score {
    [self.scoreRotateView setScore:score];
    NSLog(@"选择器--%zd", score);
}

- (void)scoreRotateView:(ScoreRotateView *)scoreView scoreChange:(NSInteger)score {
    [self.scorePickerView setScore:score];
    NSLog(@"滚盘--%zd", score);
}

@end
