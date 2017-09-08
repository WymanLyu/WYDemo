//
//  ViewController.h
//  8-3AnimationTime
//
//  Created by wyman on 2017/8/3.
//  Copyright © 2017年 wyman. All rights reserved.
//


#define BASE_URL_TEST @"192.231.0.123"    // 0
#define BASE_URL_TEST1 @"192.231.0.123.1" // 2
#define BASE_URL_TEST2 @"192.231.0.123。2" // 3
#define BASE_URL_PRODUCT @"www.baidu.com"


// 1代表发布 2代表测试 3

#if PRODUCT==1

    #define BASE_URL BASE_URL_PRODUCT

#elif PRODUCT==2

    #define BASE_URL BASE_URL_TEST1

#elif PRODUCT==3

    #define BASE_URL BASE_URL_TEST2

#else

    #define BASE_URL BASE_URL_TEST

#endif





#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end

