//
//  CoreTextData.h
//  WYCoreTextDemo
//
//  Created by sialice on 16/5/16.
//  Copyright © 2016年 wyman. All rights reserved.
//  文本模型

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface CoreTextData : NSObject

/** 文本对象 */
@property (assign, nonatomic) CTFrameRef ctFrame;

/** 文本高度 */
@property (assign, nonatomic) CGFloat height;

@end
