//
//  YSProtocolExtension.h
//  YouSay
//
//  Created by wyman on 2016/12/12.
//  Copyright © 2016年 tykj. All rights reserved.
//

#ifndef YSProtocolExtension_h
#define YSProtocolExtension_h

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

// 注入默认协议的函数
extern void _ys_load_protocol(Protocol *protocol, Class containerClass);

// 连接符防止重命名
#define __YS_CONNECT__(A,B) A##B

// 默认实现的宏函数
#define defaultImplementation(protocol_name) \
@interface protocol_name : NSObject <protocol_name> \
@end\
@implementation protocol_name \
+ (void)load { \
    _ys_load_protocol(@protocol(protocol_name), [protocol_name class]); \
} \


#endif /* YSProtocolExtension_h */
