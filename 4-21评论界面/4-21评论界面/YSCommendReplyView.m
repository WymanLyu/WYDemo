//
//  YSCommendReplyView.m
//  HeiPa
//
//  Created by wyman on 2017/2/25.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import "YSCommendReplyView.h"
#import "WYShareButton.h"
#import "WYShareView.h"

#define SHAREVIEW_HEIGHT 50
#define SHAREVIEW_HORIZON_MARGIN 0

@interface YSCommendReplyView ()<WYShareButtonDelegate, WYShareViewDelegate>

/** 操作视图 */
@property (nonatomic, weak) UIView *optionView;
@property (nonatomic, weak)  UIButton *shareCountBtn;
@property (nonatomic, weak) UIButton *collectCountBtn;
@property (nonatomic, weak) UIButton *commentCountBtn;
@property (nonatomic, weak) UIButton *praiseCountBtn;
@property (nonatomic, weak) UIButton *recordBtn;

/** 分享 */
@property (nonatomic, weak) WYShareButton *shareBtn;
@property (nonatomic, weak) WYShareView *shareView;
@property (nonatomic, strong) UIImageView *snapAniView;
@property (nonatomic, weak) UIButton *maskTouchView;

/** 回复视图 */
@property (nonatomic, weak) UIView *replyView;

@property (nonatomic, weak)  UITextView *textView;

@end

@implementation YSCommendReplyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor wy_colorWithHexInt:0x2b2b2b alpha:0.98];
        [self setupOptionView];
        [self setupReplyView];

        self.replyView.hidden = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.optionView.frame = self.bounds;
    self.replyView.frame = self.bounds;
    
    [self.shareCountBtn wy_layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:fitH(8)];
    [self.collectCountBtn wy_layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:fitH(8)];
    [self.commentCountBtn wy_layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:fitH(8)];
    [self.praiseCountBtn wy_layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:fitH(8)];
    
    CGFloat w = self.shareCountBtn.imageView.frame.size.width > self.shareCountBtn.imageView.frame.size.height ? self.shareCountBtn.imageView.frame.size.width : self.shareCountBtn.imageView.frame.size.height;
    CGFloat marginT = fabs(self.shareCountBtn.imageView.frame.size.width-self.shareCountBtn.imageView.frame.size.height)*0.5;
    self.shareBtn.backgroundColor = self.backgroundColor;
    self.shareBtn.hitTestRect = self.shareCountBtn.bounds;
    if (CGRectEqualToRect(self.shareBtn.frame, CGRectZero)) {
        self.shareBtn.frame = CGRectMake(self.shareCountBtn.imageView.frame.origin.x, self.shareCountBtn.imageView.frame.origin.y-marginT, w, w);
        [self.shareBtn forceLayout];
    }
}


//- (void)setSongModel:(YSSongModel *)songModel {
//    _songModel= songModel;
//    self.praiseCountBtn.selected = _songModel.hasPraise;
//    self.collectCountBtn.selected = _songModel.hasCollect;
//    
//    if (_songModel.commentCount.integerValue > 0) {
//        [self.commentCountBtn setTitle:_songModel.commentCount.stringValue];
//    } else {
//        [self.commentCountBtn setTitle:@"评论"];
//    }
//    
//    if (_songModel.praiseCount.integerValue > 0) {
//        [self.praiseCountBtn setTitle:_songModel.praiseCount.stringValue];
//    } else {
//        [self.praiseCountBtn setTitle:@"点赞"];
//    }
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
//    
//}

- (void)setupOptionView {
    UIView *optionView = [[UIView alloc] init];
    [self addSubview:optionView];
    _optionView = optionView;
    
    // 录音
    UIButton *recordBtn = [UIButton new];
    [recordBtn setImage:[UIImage imageNamed:@"play_button_record"] forState:UIControlStateNormal];
    [recordBtn setBackgroundColor:[UIColor wy_colorWithHexInt:0x8e8e8e]];
    [recordBtn addTarget:self action:@selector(recordBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_optionView addSubview:recordBtn];
    _recordBtn = recordBtn;
    
    // 收藏
    UIButton *collectCountBtn = [UIButton new];
    [collectCountBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectCountBtn setBackgroundColor:self.backgroundColor];
    [collectCountBtn setImage:[UIImage imageNamed:@"play_button_keep"] forState:UIControlStateNormal];
    [collectCountBtn setImage:[UIImage imageNamed:@"play_button_keep2"] forState:UIControlStateSelected];
    [collectCountBtn setTitleColor:[UIColor wy_colorWithHexInt:0xff9500] forState:UIControlStateSelected];
    [collectCountBtn.titleLabel setFont:[UIFont systemFontOfSize:10.f]];
//    [collectCountBtn addTarget:self action:@selector(collectClick:)];
    [_optionView addSubview:collectCountBtn];
    _collectCountBtn = collectCountBtn;
    
    // 评论
    UIButton *commentCountBtn = [UIButton new];
    [commentCountBtn setTitle:@"0" forState:UIControlStateNormal];
    [commentCountBtn setBackgroundColor:self.backgroundColor];
    [commentCountBtn setImage:[UIImage imageNamed:@"play_button_judge"] forState:UIControlStateNormal];
    [commentCountBtn.titleLabel setFont:[UIFont systemFontOfSize:10.f]];
//    [commentCountBtn addTarget:self action:@selector(commentClick:)];
    [_optionView addSubview:commentCountBtn];
    _commentCountBtn = commentCountBtn;
    
    // 点赞
    UIButton *praiseCountBtn = [UIButton new];
    [praiseCountBtn setTitle:@"点赞" forState:UIControlStateNormal];
    [praiseCountBtn setBackgroundColor:self.backgroundColor];
    [praiseCountBtn setImage:[UIImage imageNamed:@"play_button_like"] forState:UIControlStateNormal];
    [praiseCountBtn setImage:[UIImage imageNamed:@"play_button_like2"] forState:UIControlStateSelected];
    [praiseCountBtn setTitleColor:[UIColor wy_colorWithHexInt:0xff9500] forState:UIControlStateSelected];
    [praiseCountBtn.titleLabel setFont:[UIFont systemFontOfSize:10.f]];
//    [praiseCountBtn addTarget:self action:@selector(praiseClick:)];
    [_optionView addSubview:praiseCountBtn];
    _praiseCountBtn = praiseCountBtn;
    
    
    // 转发
    UIButton *shareCountBtn = [UIButton new];
    [shareCountBtn setBackgroundColor:self.backgroundColor];
    [shareCountBtn setTitle:@"转发" forState:UIControlStateNormal];
    [shareCountBtn setImage:[UIImage imageNamed:@"play_button_repost"] forState:UIControlStateNormal];
    [shareCountBtn.titleLabel setFont:[UIFont systemFontOfSize:10.f]];
//    [shareCountBtn addTarget:self action:@selector(share)];
    [_optionView addSubview:shareCountBtn];
    _shareCountBtn = shareCountBtn;
    // 新版本的分享动效
    WYShareButton *shareBtn = [[WYShareButton alloc] initWithFrame:CGRectZero];
    shareBtn.delegate = self;
    [_shareCountBtn addSubview:shareBtn];
    _shareBtn = shareBtn;
    WYShareView *shareView = [[WYShareView alloc] initWithFrame:CGRectMake(SHAREVIEW_HORIZON_MARGIN, -SHAREVIEW_HEIGHT, [UIScreen mainScreen].bounds.size.width-2*SHAREVIEW_HORIZON_MARGIN, SHAREVIEW_HEIGHT)]; //-SHAREVIEW_HORIZON_MARGIN
    [self insertSubview:shareView atIndex:0];// insertSubview:shareView belowSubview:_optionView];
    _shareView = shareView;
    _shareView.delegate = self;
//    _shareView.sharePlatform = [YSShare installPlatForm];
    _shareView.backgroundColor = [UIColor wy_colorWithHexInt:0x444444];// self.backgroundColor;
    _shareView.hidden = YES;
    _shareView.clipsToBounds= YES;
    

}


- (void)setupReplyView {
    UIView *replyView = [[UIView alloc] init];
    [self addSubview:replyView];
    _replyView = replyView;
    
    // 发送按钮
    UIButton *sendBtn = [[UIButton alloc] init];
    [sendBtn setImage:[UIImage imageNamed:@"play_button_send"] forState:UIControlStateNormal];
    [sendBtn setBackgroundColor:[UIColor wy_colorWithHexInt:0x8e8e8e]];
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_replyView addSubview:sendBtn];
    
    // 输入框
    UITextView *textView = [[UITextView alloc] init];
//    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc]initWithString:@"发布评论"];
//    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor wy_colorWithHexInt:0x999999] range:NSMakeRange(0, attributedStr.length)];
//    textView.attributedPlaceholder = attributedStr;
    textView.tintColor = [UIColor wy_colorWithHexInt:0xff9500];
    textView.font = [UIFont systemFontOfSize:14.0f];
    textView.textColor = [UIColor wy_colorWithHexInt:0x999999];
    [_replyView addSubview:textView];
    self.textView = textView;
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(replyView);
        make.top.equalTo(replyView);
        make.bottom.equalTo(replyView);
        make.width.mas_equalTo(fitW(98));
    }];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(sendBtn);
//        make.left.equalTo(replyView).offset(20);
//        make.right.equalTo(sendBtn.mas_left).offset(-20);
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    [self.replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

/** 操作栏到回复栏 */
- (void)animateShowOptionView2ReplyView:(BOOL)fromOptionView {
    
    if (fromOptionView) { // 从optionView-》replyView
        
        self.optionView.hidden = YES;
        self.replyView.hidden = NO;
        
    } else {  // 从replyView-》optionView
        
        self.optionView.hidden = NO;
        self.replyView.hidden = YES;
    }
}

/** 分享操作 */
- (void)share {
//    [YSShare shareWithSong:self.songModel];
}

/** 收藏操作 */
- (void)collectClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(commendReplyView:collectBtnClicked:)]) {
        [self.delegate commendReplyView:self collectBtnClicked:btn];
    }
}

/** 评论操作 */
- (void)commentClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(commendReplyView:commentBtnClicked:)]) {
        [self.delegate commendReplyView:self commentBtnClicked:btn];
    }
}

/** 点赞操作 */
- (void)praiseClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(commendReplyView:praiseBtnClicked:)]) {
        [self.delegate commendReplyView:self praiseBtnClicked:btn];
    }
}


/** 发送按钮点击 */
- (void)sendBtnClick {
    [self.textView resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(commendReplyView:sendBtnClicked:)]) {
//        [self.delegate commendReplyView:self sendBtnClicked:self.];
    }
}

/** 录音操作 */
- (void)recordBtnClick {
    if ([self.delegate respondsToSelector:@selector(commendReplyView:recordBtnClick:)]) {
        [self.delegate commendReplyView:self recordBtnClick:self.recordBtn];
    }
}

#pragma mark - 通知

- (void)keyboardWillChange:(NSNotification *)notification {
    NSLog(@"%@", notification);
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 执行动画
    CGRect f = self.frame;
    f.origin.y = keyboardF.origin.y - f.size.height;
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
//        if (keyboardF.origin.y > self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
//            self.toolbar.y = self.view.height - self.toolbar.height;
//        } else {
//            self.toolbar.y = keyboardF.origin.y - self.toolbar.height;
//        }
        self.frame= f;
    }];

}

#pragma mark - WYShareViewDelegate
- (void)shareViewItemPlatFormClick:(SharePlatform)sharePlatform {
//    [YSShare shareSong:self.songModel toPlatForm:sharePlatform];
}

#pragma mark - WYShareButtonDelegate

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.shareView.hidden && CGRectContainsPoint(self.shareView.frame, point)) {
        return [self.shareView hitTest:[self convertPoint:point toView:self.shareView] withEvent:event];
    } else {
        return [super hitTest:point withEvent:event];
    }
}

- (void)maskBtnClick {
    [self.shareBtn disSelect];
}


// - 动画状态
- (void)shareButtonStateNormal2SelecteAnimateBegin:(WYShareButton *)shareBtn {
    
    if (self.snapAniView || !self.shareView.sharePlatSubBtns.count) {
        return;
    }
    shareBtn.userInteractionEnabled = NO;
    [self.shareView.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            btn.imageView.hidden = YES;
        }
    }];
    self.shareView.hidden = NO;
    self.snapAniView = [[UIImageView alloc] initWithImage:self.shareView.wy_snapshotImage];
    self.snapAniView.frame = CGRectMake(self.shareView.frame.origin.x, 0, self.shareView.frame.size.width, self.shareView.frame.size.height);// self.shareBtn.frame;
    [self insertSubview:self.snapAniView belowSubview:self.optionView];
    self.shareView.hidden = YES;
    
    // 添加蒙版
    UIButton *maskTouchView = [UIButton new];
    maskTouchView.frame = self.superview.bounds;
//    [maskTouchView addTarget:self action:@selector(maskBtnClick)];
    [self.superview insertSubview:maskTouchView belowSubview:self];
    _maskTouchView = maskTouchView;
    _maskTouchView.enabled = NO;
    
    // table随动
    if ([self.delegate respondsToSelector:@selector(commendReplyView:shareBeginAnimateStartDuration:)]) {
        [self.delegate commendReplyView:self shareBeginAnimateStartDuration:self.shareBtn.animateTime];
    }
    [UIView animateWithDuration:self.shareBtn.animateTime delay:self.shareBtn.animateTime*0.05 usingSpringWithDamping:300 initialSpringVelocity:25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
         self.snapAniView.frame = self.shareView.frame;
    } completion:^(BOOL finished) {
        [self.shareView.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)obj;
                btn.imageView.hidden = NO;
            }
        }];
        self.shareView.hidden = NO;
        self.shareBtn.midLayer1.hidden = YES;
        self.shareBtn.midLayer2.hidden = YES;
        self.shareBtn.midLayer3.hidden = YES;
        
        self.snapAniView.hidden= YES;
        [self.snapAniView removeFromSuperview];
        self.snapAniView = nil;
        shareBtn.userInteractionEnabled = YES;
        _maskTouchView.enabled = YES;
    }];
    
}

- (void)shareButtonStateSelecte2NormalAnimateBegin:(WYShareButton *)shareBtn {
    
    if (self.snapAniView || !self.shareView.sharePlatSubBtns.count) {
        return;
    }
    shareBtn.userInteractionEnabled = NO;
    [self.shareView.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            btn.imageView.hidden = YES;
        }
    }];
    self.shareView.hidden = NO;
    [self.shareView.scrollView setContentOffset:CGPointZero animated:NO];
    self.snapAniView = [[UIImageView alloc] initWithImage:self.shareView.wy_snapshotImage];
    self.snapAniView.frame = self.shareView.frame;
    [self insertSubview:self.snapAniView belowSubview:self.optionView];
    
    self.shareBtn.midLayer1.hidden = NO;
    self.shareBtn.midLayer2.hidden = NO;
    self.shareBtn.midLayer3.hidden = NO;
    self.shareView.hidden = YES;
    
    // table随动
    if ([self.delegate respondsToSelector:@selector(commendReplyView:shareEndAnimateStartDuration:)]) {
        [self.delegate commendReplyView:self shareEndAnimateStartDuration:self.shareBtn.animateTime];
    }
    
    [UIView animateWithDuration:self.shareBtn.animateTime delay:0.035 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.snapAniView.frame =  CGRectMake(self.shareView.frame.origin.x, 0, self.shareView.frame.size.width, self.shareView.frame.size.height);// self.shareBtn.frame;
    } completion:^(BOOL finished) {
        [self.shareView.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)obj;
                btn.imageView.hidden = NO;
            }
        }];
        self.snapAniView.hidden= YES;
        self.snapAniView = nil;
        [self.snapAniView removeFromSuperview];
        shareBtn.userInteractionEnabled = YES;
        [self.maskTouchView removeFromSuperview];
        self.maskTouchView = nil;
    }];
}


// - 获取目标数据
- (WYShareButtonAnimateTargetData *)shareButtonFirstMidLayerTargetData:(WYShareButton *)shareBtn {
    WYShareButtonAnimateTargetData *data = [WYShareButtonAnimateTargetData new];
//    if (self.shareView.scrollView.subviews.count < 1) {
    if (self.shareView.sharePlatSubBtns.count < 1) {
        data.targetCenterPoint = [shareBtn convertPoint:shareBtn.midP1 toView:[UIApplication sharedApplication].keyWindow];
    } else {
        UIButton *subBtn1 = self.shareView.sharePlatSubBtns[0];// [self.shareView.scrollView.subviews objectAtIndex:0];
        data.targetCenterPoint = [subBtn1 convertPoint:subBtn1.imageView.center toView:[UIApplication sharedApplication].keyWindow];
        data.targetSize = subBtn1.imageView.bounds.size;
        data.targetImg = subBtn1.imageView.image;
    }
    return data;
}

- (WYShareButtonAnimateTargetData *)shareButtonSecondMidLayerTargetData:(WYShareButton *)shareBtn {
    WYShareButtonAnimateTargetData *data = [WYShareButtonAnimateTargetData new];
    if (self.shareView.sharePlatSubBtns.count < 2) {
        data.targetCenterPoint = [shareBtn convertPoint:shareBtn.midP2 toView:[UIApplication sharedApplication].keyWindow];
    } else {
        UIButton *subBtn2 = self.shareView.sharePlatSubBtns[1];//  [self.shareView.scrollView.subviews objectAtIndex:1];
        data.targetCenterPoint = [subBtn2 convertPoint:subBtn2.imageView.center toView:[UIApplication sharedApplication].keyWindow];
        data.targetSize = subBtn2.imageView.bounds.size;
        data.targetImg = subBtn2.imageView.image;
    }
    return data;
}

- (WYShareButtonAnimateTargetData *)shareButtonThirstMidLayerTargetData:(WYShareButton *)shareBtn {
    WYShareButtonAnimateTargetData *data = [WYShareButtonAnimateTargetData new];
    if (self.shareView.sharePlatSubBtns.count < 3) {
        data.targetCenterPoint = [shareBtn convertPoint:shareBtn.midP1 toView:[UIApplication sharedApplication].keyWindow];
    } else {
        UIButton *subBtn3 = self.shareView.sharePlatSubBtns[2];//  [self.shareView.scrollView.subviews objectAtIndex:2];
        data.targetCenterPoint = [subBtn3 convertPoint:subBtn3.imageView.center toView:[UIApplication sharedApplication].keyWindow];
        data.targetSize = subBtn3.imageView.bounds.size;
        data.targetImg = subBtn3.imageView.image;
    }
    return data;
}



@end
