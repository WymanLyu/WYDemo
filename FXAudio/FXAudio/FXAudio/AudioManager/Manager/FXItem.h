//
//  FXItem.h
//  FXAudio
//
//  Created by wyman on 2017/7/27.
//  Copyright © 2017年 wyman. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "FxConstants.h"
#import "AMConst.h"

extern NSString * const UPDATE_FX_PROPERTY;

@interface FXItem : NSObject
{
@protected
    BOOL _enble;
}

/** 名称 */
@property (nonatomic, copy) NSString *fxName;

/** id */
@property (nonatomic, assign) long fxId;

/** 开关,默认关闭 */
@property (nonatomic, assign) BOOL enble;


- (instancetype)initWithFXId:(long)fxId;

#pragma mark - 子类重写
- (void)process:(float *)input output:(float *)output numberOfSamples:(unsigned int)numberOfSamples; // 子类重写

#pragma mark - 工具方法
+ (NSString *)getFXNameFromFXId:(long)fxId;

@end
