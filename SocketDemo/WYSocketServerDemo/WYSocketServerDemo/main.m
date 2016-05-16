//
//  main.m
//  WYSocketServerDemo
//
//  Created by sialice on 16/5/16.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYServer.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 1.开启服务器Socket监听
        WYServer *server = [[WYServer alloc] init];
        [server start];
        
        // 2.进入Runloop
        [[NSRunLoop mainRunLoop] run];
    }
    return 0;
}
