//
//  MovieItem.h
//  WYAVFoundationDemo
//
//  Created by yunyao on 16/7/25.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIImage;

@interface MovieItem : NSObject
//"id": 1,
//"image": "resources/images/minion_01.png",
//"length": 10,
//"name": "小黄人 第01部",
//"url": "resources/videos/minion_01.mp4"

@property (nonatomic, assign) NSInteger base_id;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;


@property (nonatomic, strong) UIImage *img;

+ (instancetype)itemWithDict:(NSDictionary *)dict;


@end
