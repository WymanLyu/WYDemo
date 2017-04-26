//
//  WYInputAccessoryToolView.m
//  4-21评论界面
//
//  Created by wyman on 2017/4/23.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYInputAccessoryToolView.h"

@interface WYInputAccessoryToolView ()

@property (nonatomic, strong) UIButton *albumBtn;

@property (nonatomic, strong) UIButton *cameraBtn;

@property (nonatomic, strong) UIButton *emoteBtn;

@end

@implementation WYInputAccessoryToolView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.inputAccessoryType = InputAccessoryTypeAlbum | InputAccessoryTypeCamera;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat itemW = self.frame.size.width / self.subviews.count;
    for (int i = 0; i < self.subviews.count; i++) {
        UIView *subView = [self.subviews objectAtIndex:i];
        subView.frame = CGRectMake(i*itemW, 0, itemW, self.frame.size.height);
    }
    
}

- (void)setInputAccessoryType:(InputAccessoryType)inputAccessoryType {
    _inputAccessoryType = inputAccessoryType;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (_inputAccessoryType & InputAccessoryTypeAlbum) { // 相册
        [self addSubview:self.albumBtn];
    }
    if (_inputAccessoryType & InputAccessoryTypeCamera) { // 相机
        [self addSubview:self.cameraBtn];
    }
    if (_inputAccessoryType & InputAccessoryTypeEmote) { // 表情
        [self addSubview:self.emoteBtn];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - 事件

- (void)albumBtnClick {
    if ([self.delegate respondsToSelector:@selector(inputAccessoryToolViewAlbumBtnClick:)]) {
        [self.delegate inputAccessoryToolViewAlbumBtnClick:self];
    }
}

- (void)cameraBtnClick {
    if ([self.delegate respondsToSelector:@selector(inputAccessoryToolViewCameraBtnClickClick:)]) {
        [self.delegate inputAccessoryToolViewCameraBtnClickClick:self];
    }
}

- (void)emoteBtnClick {
    if ([self.delegate respondsToSelector:@selector(inputAccessoryToolViewEmoteBtnClickClick:)]) {
        [self.delegate inputAccessoryToolViewEmoteBtnClickClick:self];
    }
}

#pragma mark - 懒加载

- (UIButton *)albumBtn {
    if (!_albumBtn) {
        _albumBtn = [[UIButton alloc] init];
        _albumBtn.tag = InputAccessoryTypeAlbum;
        [_albumBtn setImage:[UIImage imageNamed:@"comment_icon_picture"] forState:UIControlStateNormal];
        [_albumBtn addTarget:self action:@selector(albumBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _albumBtn;
}

- (UIButton *)cameraBtn {
    if (!_cameraBtn) {
        _cameraBtn = [[UIButton alloc] init];
        _cameraBtn.tag = InputAccessoryTypeCamera;
        [_cameraBtn setImage:[UIImage imageNamed:@"comment_icon_camera"] forState:UIControlStateNormal];
        [_cameraBtn addTarget:self action:@selector(cameraBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraBtn;
}

- (UIButton *)emoteBtn {
    if (!_emoteBtn) {
        _emoteBtn = [[UIButton alloc] init];
        _emoteBtn.tag = InputAccessoryTypeEmote;
        [_emoteBtn setImage:[UIImage imageNamed:@"comment_icon_emjio"] forState:UIControlStateNormal];
        [_emoteBtn addTarget:self action:@selector(emoteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emoteBtn;
}

@end
