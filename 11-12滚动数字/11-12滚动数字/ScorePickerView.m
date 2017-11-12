//
//  ScorePickerView.m
//  11-12滚动数字
//
//  Created by wyman on 2017/11/12.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ScorePickerView.h"
#import "UIPickerView+WY.h"

@interface ScorePickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray<UIImage *> *imgArr;
@property (nonatomic, strong) UIPickerView *pickView;

@property (nonatomic, assign) NSInteger currentEnterTen; // 当前进十位数
@property (nonatomic, assign) NSInteger currentEnterHundred; // 当前进百位数

@property (nonatomic, assign) NSInteger currentScore;
@end

@implementation ScorePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSub];
    }
    return self;
}

- (void)setupSub {
    UIPickerView *pickView = [[UIPickerView alloc] init];
    pickView.backgroundColor = [UIColor yellowColor];
    pickView.delegate = self;
    pickView.dataSource = self;
    pickView.frame = CGRectMake(0, 0, ITEM_W*3+ITEM_EX*2, ITEM_H+ITEM_EX*2);
    [self addSubview:pickView];
    self.pickView = pickView;
    
    UIView *topLineView = [[UIView alloc] init];
    topLineView.frame = CGRectMake(0, 0, ITEM_W*3+ITEM_EX*2, ITEM_EX);
    topLineView.backgroundColor = [UIColor yellowColor];
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.frame = CGRectMake(0, ITEM_H+ITEM_EX, ITEM_W*3+ITEM_EX*2, ITEM_EX);
    bottomLineView.backgroundColor = [UIColor yellowColor];
    
    UIView *disScrollMask = [[UIView alloc] init];
    disScrollMask.backgroundColor = [UIColor clearColor];
    disScrollMask.frame = CGRectMake(0, 0, ITEM_W*2+ITEM_EX, ITEM_H+ITEM_EX*2);
    
    [pickView addSubview:topLineView];
    [pickView addSubview:bottomLineView];
    [self addSubview:disScrollMask];
}

- (NSArray *)imgArr {
    if (!_imgArr) {
        _imgArr = @[[UIImage imageNamed:@"0"],[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"3"],[UIImage imageNamed:@"4"],[UIImage imageNamed:@"5"],[UIImage imageNamed:@"6"],[UIImage imageNamed:@"7"],[UIImage imageNamed:@"8"],[UIImage imageNamed:@"9"]];
    }
    return _imgArr;
}

- (void)currentSelectBPM {
    NSInteger bpm = 0;
    NSInteger hundred = ([self.pickView selectedRowInComponent:0] % 10) * 100;
    NSInteger ten = ([self.pickView selectedRowInComponent:1] % 10) * 10;
    NSInteger digit = ([self.pickView selectedRowInComponent:2] % 10) * 1;
    bpm = hundred+ten+digit;
    if (bpm!=self.currentScore) {
        if ([self.delegate respondsToSelector:@selector(scorePickerView:scoreChange:)]) {
            [self.delegate scorePickerView:self scoreChange:bpm];
        }
    }
    self.currentScore = bpm;
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return ITEM_W;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return ITEM_H;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component==0) { // 百位
        
    } else if (component==1) { // 十位
        NSInteger enterHundred = row/10; // 进位数
        NSInteger add = enterHundred-self.currentEnterHundred;
        self.currentEnterHundred = enterHundred;
        NSInteger hundred = [self.pickView selectedRowInComponent:0];
        [pickerView selectRow:hundred+add inComponent:0 animated:YES];
    } else { // 个位
        NSInteger enterTen = row/10; // 进位数
        NSInteger add = enterTen-self.currentEnterTen;
        self.currentEnterTen = enterTen;
        NSInteger ten = [self.pickView selectedRowInComponent:1];
        [pickerView selectRow:ten+add inComponent:1 animated:YES];
        [self pickerView:pickerView didSelectRow:ten+add inComponent:1];
    }
    [self currentSelectBPM];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UIImageView *imgView = (UIImageView *)view;
    if (!imgView) {
        imgView = [[UIImageView alloc] init];
        imgView.bounds = CGRectMake(0, 0, ITEM_W, ITEM_H);
    } else {
        NSLog(@"重用...");
    }
    imgView.image = [self.imgArr objectAtIndex:row%10];
    [pickerView wy_clearSpearatorLine];
    return imgView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 10 * 100;
}


- (void)setScore:(NSInteger)score {
    [self.pickView selectRow:234 inComponent:2 animated:YES];
    [self pickerView:self.pickView didSelectRow:234 inComponent:2];
}

- (NSInteger)currentScore {
    return _currentScore;
}

@end
