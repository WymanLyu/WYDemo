//
//  WYDownloadOperation.h
//  Rapid
//
//  Created by wyman on 2017/9/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WYDownloadOperation <NSObject>

@required
/** 取消 */
- (void)cancel;
/** 挂起 */
- (void)suspend;
/** 继续 */
- (void)resume;
/** 即将下载 */
- (void)willResume;

- (void)didReceiveResponse:(NSHTTPURLResponse *)response;
- (void)didReceiveData:(NSData *)data;
- (void)didCompleteWithError:(NSError *)error;


@end

