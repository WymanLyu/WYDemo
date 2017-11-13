//
//  ScoreRotateView.h
//  11-12滚动数字
//
//  Created by wyman on 2017/11/12.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ROTATE_VIEW_W 524.0
#define ROTATE_VIEW_H_SCALE (692.0/524.0)

@class ScoreRotateView;
@protocol ScoreRotateViewDelegate <NSObject>

@optional
- (void)scoreRotateView:(ScoreRotateView *)scoreView scoreChange:(NSInteger)score;

@end

@interface ScoreRotateView : UIView

@property (nonatomic, weak) id<ScoreRotateViewDelegate> delegate;

- (void)setScore:(NSInteger)score;
- (NSInteger)score;

- (void)resetBPMDetect;

@end
