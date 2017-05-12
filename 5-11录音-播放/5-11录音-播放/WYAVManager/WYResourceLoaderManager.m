//
//  WYResourceLoaderManager.m
//  WYAVFoundationDemo
//
//  Created by yunyao on 16/7/26.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "WYResourceLoaderManager.h"

@implementation WYResourceLoaderManager

#pragma mark - AVAssetResourceLoaderDelegate

// 获取AVAsset不能处理的URL，返回YES表示由自己处理改请求
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    return YES;
}



@end
