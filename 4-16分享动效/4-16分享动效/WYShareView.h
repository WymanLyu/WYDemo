//
//  WYShareView.h
//  4-16分享动效
//
//  Created by wyman on 2017/4/16.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SharePlatform) {
    SharePlatformWechatSession      = 2,    // 微信聊天
    SharePlatformQQSession          = 4,    // qq聊天
    SharePlatformSinaWeibo          = 8,    // 新浪微博
    SharePlatformWechatTimeline     = 16,   // 微信朋友圈
    SharePlatformWechatFav          = 32,   // 微信收藏
    SharePlatformQZone              = 64,   // qq空间
    SharePlatformAllIfExist         = 126,  // 所有平台
};

@interface WYShareItem : NSObject

@property (nonatomic, copy) NSString *iconImgName;

@property (nonatomic, copy) NSString *iconName;

@property (nonatomic, assign) SharePlatform sharePlatform;

- (instancetype)initWithIconName:(NSString *)iconName iconImgName:(NSString *)iconImgName sharePlatform:(SharePlatform)sharePlatform;

@end

@interface WYShareView : UIView

/** 容器 */
@property (nonatomic, weak) UIScrollView *scrollView;

/** 分享平台 默认是所有平台 */
@property (nonatomic, assign) SharePlatform sharePlatform;

/** 平台图标 */
@property (nonatomic, strong) NSMutableArray<WYShareItem *> *sharePlatforms;

@end


