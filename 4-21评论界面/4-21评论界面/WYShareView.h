//
//  WYShareView.h
//  4-16分享动效
//
//  Created by wyman on 2017/4/16.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WYShareViewDelegate <NSObject>

- (void)shareViewItemPlatFormClick:(SharePlatform )sharePlatform;

@end

@interface WYShareItem : NSObject

@property (nonatomic, copy) NSString *iconImgName;

@property (nonatomic, copy) NSString *iconName;

@property (nonatomic, assign) SharePlatform sharePlatform;

- (instancetype)initWithIconName:(NSString *)iconName iconImgName:(NSString *)iconImgName sharePlatform:(SharePlatform)sharePlatform;

@end

@interface WYShareView : UIView

/** 代理 */
@property (nonatomic, weak) id<WYShareViewDelegate> delegate;

/** 容器 */
@property (nonatomic, weak) UIScrollView *scrollView;

/** 分享平台 默认是所有平台 */
@property (nonatomic, assign) SharePlatform sharePlatform;

/** 平台图标 */
@property (nonatomic, strong) NSMutableArray<WYShareItem *> *sharePlatforms;

/** 子视图 */
@property (nonatomic, strong) NSMutableArray<UIButton *> *sharePlatSubBtns;

@end


