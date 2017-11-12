//
//  ScorePickerView.h
//  11-12滚动数字
//
//  Created by wyman on 2017/11/12.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ITEM_W 52
#define ITEM_H 50
#define ITEM_EX 30

@class ScorePickerView;
@protocol ScorePickerViewDelegate <NSObject>

@optional
- (void)scorePickerView:(ScorePickerView *)scoreView scoreChange:(NSInteger)score;

@end

@interface ScorePickerView : UIView

@property (nonatomic, weak) id<ScorePickerViewDelegate> delegate;

- (void)setScore:(NSInteger)score;
- (NSInteger)currentScore;


@end
