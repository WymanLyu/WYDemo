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
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController () <ScorePickerViewDelegate, ScoreRotateViewDelegate>

@property (nonatomic, strong) ScorePickerView *scorePickerView;

@property (nonatomic, strong) ScoreRotateView *scoreRotateView;

@property (nonatomic, strong) UIButton *resetBtn;

@property (nonatomic, assign) CGFloat selectedBPM;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.scorePickerView = [[ScorePickerView alloc] initWithFrame:CGRectMake(30, 200, ITEM_W*3+ITEM_EX*2, ITEM_H+ITEM_EX*2)];
    self.scorePickerView.delegate = self;
    [self.view addSubview:self.scorePickerView];
    [self.scorePickerView setScore:50];
    
    self.scoreRotateView = [[ScoreRotateView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-(ROTATE_VIEW_W/2), [UIScreen mainScreen].bounds.size.height-((ROTATE_VIEW_H_SCALE*ROTATE_VIEW_W)/2), ROTATE_VIEW_W, ROTATE_VIEW_W)];
    self.scoreRotateView.backgroundColor = [UIColor lightGrayColor];
    self.scoreRotateView.delegate = self;
    [self.view addSubview:self.scoreRotateView];
    
    self.resetBtn = [[UIButton alloc] init];
    [self.resetBtn setBackgroundColor:[UIColor yellowColor]];
    [self.resetBtn setImage:[UIImage imageNamed:@"reset_"] forState:UIControlStateNormal];
    [self.view addSubview:self.resetBtn];
    self.resetBtn.frame = CGRectMake(33, 55, 30, 40);
    [self.resetBtn addTarget:self action:@selector(resetBtnClick) forControlEvents:UIControlEventTouchUpInside];

}

- (void)resetBtnClick {
    [self.scoreRotateView resetBPMDetect];
    [self.scorePickerView setScore:50];
}

- (void)scorePickerView:(ScorePickerView *)scoreView scoreChange:(NSInteger)score {
    [self.scoreRotateView setScore:score];
    self.selectedBPM = score;
    NSLog(@"选择器--%zd", score);
}

- (void)scoreRotateView:(ScoreRotateView *)scoreView scoreChange:(NSInteger)score {
    [self.scorePickerView setScore:score];
    self.selectedBPM = score;
    NSLog(@"滚盘--%zd", score);
}

- (void)setSelectedBPM:(CGFloat)selectedBPM {
    _selectedBPM = selectedBPM;
}

@end
