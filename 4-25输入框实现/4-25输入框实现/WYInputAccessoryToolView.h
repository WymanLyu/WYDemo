//
//  WYInputAccessoryToolView.h
//  4-21评论界面
//
//  Created by wyman on 2017/4/23.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYInputAccessoryToolView;
typedef NS_ENUM(NSUInteger, InputAccessoryType) {
    InputAccessoryTypeAlbum  = 2,                          // 相册
    InputAccessoryTypeCamera = InputAccessoryTypeAlbum<<1, // 相机
    InputAccessoryTypeEmote  = InputAccessoryTypeAlbum<<2, // 表情
};

@protocol WYInputAccessoryToolViewDelegate <NSObject>

- (void)inputAccessoryToolViewAlbumBtnClick:(WYInputAccessoryToolView *)inputAccessoryView;
- (void)inputAccessoryToolViewCameraBtnClickClick:(WYInputAccessoryToolView *)inputAccessoryView;
- (void)inputAccessoryToolViewEmoteBtnClickClick:(WYInputAccessoryToolView *)inputAccessoryView;

@end

@interface WYInputAccessoryToolView : UIView

@property (nonatomic, assign) InputAccessoryType inputAccessoryType;

@property (nonatomic, weak) id<WYInputAccessoryToolViewDelegate> delegate;

@end
