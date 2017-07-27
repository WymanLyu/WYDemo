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

extern NSString * const UPDATE_FX_PROPERTY;

@interface FXItem : NSObject

/** 名称 */
@property (nonatomic, copy) NSString *fxName;

/** id */
@property (nonatomic, assign) long fxId;

/** 开关,默认关闭 */
@property (nonatomic, assign) BOOL enble;

/** 更新效果器,子类在set方法中标记为YES，设置成功后会置为NO */
@property (nonatomic, assign, getter=isDirty) BOOL dirty;

- (instancetype)initWithFXId:(long)fxId;

+ (NSString *)getFXNameFromFXId:(long)fxId;

@end
