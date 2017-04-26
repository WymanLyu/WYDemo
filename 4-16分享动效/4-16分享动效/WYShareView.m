//
//  WYShareView.m
//  4-16分享动效
//
//  Created by wyman on 2017/4/16.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYShareView.h"
#import "UIColor+WY.H"

#define HORIZON_MARHIN 10
#define HORIZON_ITEM_COUNT 3.0

@implementation WYShareItem

- (instancetype)initWithIconName:(NSString *)iconName iconImgName:(NSString *)iconImgName sharePlatform:(SharePlatform)sharePlatform {
    
    if (self = [super init]) {
        _iconName = iconName;
        _iconImgName = iconImgName;
        _sharePlatform = sharePlatform;
    }
    return self;
}

@end

@interface WYShareView()


@end

@implementation WYShareView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _sharePlatform = SharePlatformAllIfExist;
        
        WYShareItem *WechatSessionItem = [[WYShareItem alloc] initWithIconName:@"" iconImgName:@"WechatSession_share_icon" sharePlatform:SharePlatformWechatSession];//微信好友
        WYShareItem *QQSessionItem = [[WYShareItem alloc] initWithIconName:@"" iconImgName:@"QQSession_share_icon" sharePlatform:SharePlatformQQSession];// qq
        WYShareItem *SinaWeiboItem = [[WYShareItem alloc] initWithIconName:@"" iconImgName:@"SinaWeibo_share_icon" sharePlatform:SharePlatformSinaWeibo]; //新浪微博
        WYShareItem *WechatTimelineItem = [[WYShareItem alloc] initWithIconName:@"" iconImgName:@"WechatTimeline_share_icon" sharePlatform:SharePlatformWechatTimeline];//微信朋友圈
        WYShareItem *WechatFavItem = [[WYShareItem alloc] initWithIconName:@"" iconImgName:@"WechatFav_share_icon" sharePlatform:SharePlatformWechatFav]; //微信收藏
        WYShareItem *QZoneItem = [[WYShareItem alloc] initWithIconName:@"" iconImgName:@"QZone_share_icon" sharePlatform:SharePlatformQZone];//qq空间
        
        _sharePlatforms = [NSMutableArray arrayWithArray:@[
                                                           WechatSessionItem,
                                                           QQSessionItem,
                                                           SinaWeiboItem,
                                                           WechatTimelineItem,
                                                           WechatFavItem,
                                                           QZoneItem,
                                                           ]];
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:scrollView];
        _scrollView = scrollView;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self setupSubBtn];
    }
    return self;
}

- (void)setupSubBtn {
    CGFloat itemBtnW = self.frame.size.width / HORIZON_ITEM_COUNT;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_sharePlatforms enumerateObjectsUsingBlock:^(WYShareItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (_sharePlatform & obj.sharePlatform) {
            UIButton *itemBtn = [[UIButton alloc] init];
            [itemBtn setImage:[UIImage imageNamed:obj.iconImgName] forState:UIControlStateNormal];
            [itemBtn setTitle:obj.iconName forState:UIControlStateNormal];
            itemBtn.tag = obj.sharePlatform;
            [self.scrollView addSubview:itemBtn];
             itemBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        }
    }];
    for (int i = 0; i < self.scrollView.subviews.count; i++) {
        UIButton *itemBtn = [self.scrollView.subviews objectAtIndex:i];
        itemBtn.frame = CGRectMake(itemBtnW*i, 0, itemBtnW, self.frame.size.height);
        [itemBtn addTarget:self action:@selector(shareItemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [itemBtn setBackgroundColor:[UIColor wy_randomColor]];
    }
    // 设置contentSize
    CGFloat contentW = self.scrollView.subviews.count * itemBtnW;
    NSInteger page = ceil(contentW / self.frame.size.width);
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width*page, self.frame.size.height);
}

- (void)setSharePlatform:(SharePlatform)sharePlatform {
    _sharePlatform = sharePlatform;
    [self setupSubBtn];
}

#pragma mark - 事件
- (void)shareItemBtnClick:(UIButton *)btn {
    switch (btn.tag) {
        case SharePlatformWechatSession:
        {
            NSLog(@"SharePlatformWechatSession--");
        }
            break;
        case SharePlatformQQSession:
        {
            NSLog(@"SharePlatformQQSession--");
        }
            break;
        case SharePlatformSinaWeibo:
        {
            NSLog(@"SharePlatformSinaWeibo--");
        }
            break;
        case SharePlatformWechatTimeline:
        {
            NSLog(@"SharePlatformWechatTimeline--");
        }
            break;
        case SharePlatformWechatFav:
        {
            NSLog(@"SharePlatformWechatFav--");
        }
            break;
        case SharePlatformQZone:
        {
            NSLog(@"SharePlatformQZone--");
        }
            break;
        case SharePlatformAllIfExist:
        {
            NSLog(@"SharePlatformAllIfExist--");
        }
            break;
            
        default:
            break;
    }
    
    
}





@end
