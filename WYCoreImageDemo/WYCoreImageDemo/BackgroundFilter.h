//
//  BackgroundFilter.h
//  WYCoreImageDemo
//
//  Created by yunyao on 16/9/13.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import <CoreImage/CoreImage.h>

extern NSString  * const inputMinHueAngle;
extern NSString  * const inputMaxHueAngle;


@interface BackgroundFilter : CIFilter

@property (nonatomic, strong) CIImage *inputImage;

@end
