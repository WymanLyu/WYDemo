//
//  ScoreRotateView.h
//  11-12滚动数字
//
//  Created by wyman on 2017/11/12.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScoreRotateView;
@protocol ScoreRotateViewDelegate <NSObject>

@optional
- (void)scoreRotateView:(ScoreRotateView *)scoreView scoreChange:(NSInteger)score;

@end

@interface ScoreRotateView : UIView

@property (nonatomic, weak) id<ScoreRotateViewDelegate> delegate;

- (void)setScore:(NSInteger)score;
- (NSInteger)score;

@end
