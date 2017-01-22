//
//  WYMagicView.h
//  KLParallaxView
//
//  Created by wyman on 2017/1/8.
//  Copyright © 2017年 dara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYMagicView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

/** 圆角 */
@property (nonatomic, assign) CGFloat cornerRadius;

/** 初始阴影半径 */
@property (nonatomic, assign) CGFloat initialShadowRadius;

/** 最终阴影半径 */
@property (nonatomic, assign) CGFloat finalShadowRadius;

/** 阴影不透明度 */
@property (nonatomic, assign) CGFloat shadowOpacity;

/** 阴影颜色 */
@property (nonatomic, strong) UIColor *shadowColor;

/** 图片 */
@property (nonatomic, strong) UIImageView *imgView;

/** 高亮 */
@property (nonatomic) BOOL glows;


@end
