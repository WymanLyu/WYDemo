//
//  ViewController.m
//  11-12滚动数字
//
//  Created by wyman on 2017/11/12.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "ScorePickerView.h"

@interface ViewController () <ScorePickerViewDelegate>

@property (nonatomic, strong) ScorePickerView *scroePickerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.scroePickerView = [[ScorePickerView alloc] initWithFrame:CGRectMake(30, 200, ITEM_W*3+ITEM_EX*2, ITEM_H+ITEM_EX*2)];
    self.scroePickerView.delegate = self;
    [self.view addSubview:self.scroePickerView];
    [self.scroePickerView setScore:55];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.scroePickerView setScore:234];
}

- (void)scorePickerView:(ScorePickerView *)scoreView scoreChange:(NSInteger)score {
    NSLog(@"%zd", score);
}

@end
