//
//  WYSoundWaveView.m
//  5-31SuperPowered
//
//  Created by wyman on 2017/6/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYSoundWaveView.h"

@interface WYSoundWaveView()

/** 当前绘制的图片视图 */
@property (nonatomic, strong) UIImageView *currentWaveImageView;

/** 是否绘制 */
@property (nonatomic, assign) BOOL drawSpaces;

/** 波形颜色 */
@property (nonatomic, strong) UIColor* waveColor;
/** 进度色 */
@property (nonatomic, strong) UIColor* progressColor;

@end

@implementation WYSoundWaveView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.waveColor = [[UIColor whiteColor] colorWithAlphaComponent:.8];
        _drawSpaces = YES;
    }
    return self;
}

- (void) layoutSubviews {
    
    [super layoutSubviews];
    
}



#pragma mark - 绘制图片
- (void)drawSaveWithSamples:(SInt16 *)samples sampleCount:(NSInteger)sampleCount {
    
   
    
//    int adjustFactor = ceilf((float)sampleCount / (self.frame.size.width / (_drawSpaces ? 2.0 : 1.0)));
//    int i = 0;
//    while (i < sampleCount) {
//        SInt16 val = 0;
//        for (int j = 0; j < adjustFactor; j++) {
//            val += samples[i + j];
//        }
//        val /= adjustFactor;
//        if (ABS(val) > maxValue) {
//            maxValue = ABS(val);
//        }
////        [adjustedSongData appendBytes:&val length:sizeof(val)];
//        i += adjustFactor;
//    }
//    NSLog(@"MAX:%zd--%@", maxValue, [NSThread currentThread]);
    NSLog(@"%zd", sampleCount);
   

    
    // 1.绘制图片
    dispatch_async(dispatch_get_main_queue(), ^{
//        _currentWaveImageView.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1];
        // 0.计算最大值
        SInt16 maxValue = 0;
        
        int i = 0;
        while (i < sampleCount) {
            if (ABS(samples[i]) > maxValue) {
                maxValue = ABS(samples[i]);
            }
            i++;
        }
        NSLog(@"MAX:%zd===%@", maxValue, [NSThread currentThread]);
        
        
        UIImage *renderedImage = [self _drawImageFromSamples:samples maxValue:maxValue sampleCount:sampleCount];
        
        
        // 2.渲染到view上
        if (renderedImage) {
            if (_currentWaveImageView == nil) {
                _currentWaveImageView = [[UIImageView alloc] initWithFrame:self.bounds];
                _currentWaveImageView.contentMode = UIViewContentModeLeft;
                
                _currentWaveImageView.clipsToBounds = YES;
                [self addSubview:_currentWaveImageView];
            }
            
            _currentWaveImageView.image = renderedImage;
            
            //        CGRect tmpRect = _currentWaveImageView.frame;
            //        tmpRect.size.width = renderedImage.size.width;
            //        tmpRect.origin.x = (self.frame.size.width - renderedImage.size.width) / 2;
            //        _currentWaveImageView.frame = tmpRect;
        }

    });
    
}

- (UIImage*)_drawImageFromSamples:(SInt16*)samples
                         maxValue:(SInt16)maxValue
                      sampleCount:(NSInteger)sampleCount {
    
    CGSize imageSize = CGSizeMake(sampleCount * (_drawSpaces ? 2 : 0), self.frame.size.height);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextSetAlpha(context, 1.0);
    
    CGRect rect;
    rect.size = imageSize;
    rect.origin.x = 0;
    rect.origin.y = 0;
    
    CGColorRef waveColor = self.waveColor.CGColor;
    
    CGContextFillRect(context, rect);
    
    CGContextSetLineWidth(context, 1.0);
    
    float channelCenterY = imageSize.height / 2;
    float sampleAdjustmentFactor = imageSize.height / (float)maxValue;
    
    for (NSInteger i = 0; i < sampleCount; i++)
    {
        float val = *samples++;
        val = val * sampleAdjustmentFactor;
        if ((int)val == 0)
            val = 1.0; // draw dots instead emptyness
        CGContextMoveToPoint(context, i * (_drawSpaces ? 2 : 1), channelCenterY - val / 2.0);
        CGContextAddLineToPoint(context, i * (_drawSpaces ? 2 : 1), channelCenterY + val / 2.0);
        CGContextSetStrokeColorWithColor(context, waveColor);
        CGContextStrokePath(context);
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
//    return nil;
}



@end
