//
//  YSCommendReplyView.h
//  HeiPa
//
//  Created by wyman on 2017/2/25.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSCommendReplyView;
@protocol YSCommendReplyViewDelegate <NSObject>

@optional
- (void)commendReplyView:(YSCommendReplyView *)replyView sendBtnClicked:(UITextField *)textField;
- (void)commendReplyView:(YSCommendReplyView *)replyView collectBtnClicked:(UIButton *)collectBtn;
- (void)commendReplyView:(YSCommendReplyView *)replyView commentBtnClicked:(UIButton *)commentBtn;
- (void)commendReplyView:(YSCommendReplyView *)replyView praiseBtnClicked:(UIButton *)praiseBtn;
- (void)commendReplyView:(YSCommendReplyView *)replyView recordBtnClick:(UIButton *)recordBtn;

// - 动画状态
- (void)commendReplyView:(YSCommendReplyView *)replyView shareBeginAnimateStartDuration:(CGFloat)time;
- (void)commendReplyView:(YSCommendReplyView *)replyView shareEndAnimateStartDuration:(CGFloat)time;

@end

@interface YSCommendReplyView : UIView

@property (nonatomic, weak) id<YSCommendReplyViewDelegate> delegate;

//@property (nonatomic, strong) YSSongModel *songModel;

/** 操作栏到回复栏 */
- (void)animateShowOptionView2ReplyView:(BOOL)fromOptionView;

@end
