//
//  FXItem.h
//  FXAudio
//
//  Created by wyman on 2017/7/27.
//  Copyright © 2017年 wyman. All rights reserved.
//
//
//  name            :       controlValueDict
//  Flanger         :      Wet Depth LFOBeats
//  Reverb          :      Dry Wet Mix Width Damp RoomSize 
//  
//

#import <Foundation/Foundation.h>

@interface FXItem : NSObject

/** 名称 */
@property (nonatomic, copy) NSString *fxName;

/** 属性名-》值[0-1] */
@property (nonatomic, strong, readonly) NSDictionary *controlValueDict;

/** 开关,默认关闭 */
@property (nonatomic, assign) BOOL enble;

- (instancetype)initWithName:(NSString *)name controlValueDict:(NSDictionary *)controlValueDict;


@end
