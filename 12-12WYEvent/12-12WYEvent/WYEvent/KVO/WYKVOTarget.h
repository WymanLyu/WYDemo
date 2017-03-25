//
//  WYKVOTarget.h
//  12-12WYEvent
//
//  Created by wyman on 2017/3/25.
//  Copyright © 2017年 tykj. All rights reserved.
//

// 这个对象是解决被监听者 挂掉后KVO的问题 【此问题暂时无解啊！！别个facebook也没解决啊】

#import <Foundation/Foundation.h>

@interface WYKVOTarget : NSObject

@property (nonatomic, weak) id wy_owner;

@end
