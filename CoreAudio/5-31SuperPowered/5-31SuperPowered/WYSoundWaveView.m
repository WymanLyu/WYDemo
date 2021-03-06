//
//  WYSoundWaveView.m
//  5-31SuperPowered
//
//  Created by wyman on 2017/6/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#define SAMPLE_LINECOUNT 1

#import "WYSoundWaveView.h"

@interface WYSoundWaveView()

/** 当前绘制的图片视图 */
@property (nonatomic, strong) UIImageView *currentWaveImageView;

/** 上一个视图 */
@property (nonatomic, strong) UIImageView *lastWaveImageView;

/** 滚动view */
@property (nonatomic, strong) UIScrollView *scrollView;

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
        self.waveColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.8];
        _drawSpaces = YES;
        
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.backgroundColor = [UIColor blackColor];
        [self addSubview:_scrollView];
        
        
        _sampleLineCount = 0;
        _needDrawHorizonLine = NO;
    }
    return self;
}

- (void) layoutSubviews {
    
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, self.frame.size.width*0.5);
}



#pragma mark - 绘制图片
- (void)drawSaveWithSamples:(SInt16 *)samples sampleCount:(NSInteger)sampleCount {
    

    NSLog(@"%zd", sampleCount);
   

    
    // 1.绘制图片
    dispatch_async(dispatch_get_main_queue(), ^{

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
        
        
//        UIImage *renderedImage = [self _drawImageFromSamples:samples maxValue:maxValue sampleCount:sampleCount];
        UIImage *renderedImage = [self _drawImageFromSamples:samples sampleCount:sampleCount];
        
        // 2.渲染到view上
        if (renderedImage) {
            if (_currentWaveImageView == nil) {
                _currentWaveImageView = [[UIImageView alloc] init];
                _currentWaveImageView.contentMode = UIViewContentModeScaleAspectFit;
                _currentWaveImageView.clipsToBounds = YES;
                [self.scrollView addSubview:_currentWaveImageView];
            }
            
            _currentWaveImageView.image = renderedImage;
            CGRect tmpRect = _currentWaveImageView.frame;
            tmpRect.size.width = renderedImage.size.width;
            tmpRect.size.height = renderedImage.size.height;
            tmpRect.origin.x = _lastWaveImageView.frame.origin.x + tmpRect.size.width;//  (self.frame.size.width - renderedImage.size.width) / 2;
            tmpRect.origin.y = 0;
            _currentWaveImageView.frame = tmpRect;
            
            _lastWaveImageView = _currentWaveImageView;
            _currentWaveImageView = nil;
            if (CGRectGetMaxX(tmpRect) > self.bounds.size.width) {
                _scrollView.contentSize = CGSizeMake(CGRectGetMaxX(tmpRect), 0); //  + self.bounds.size.width*0.5
                if (_scrollView.isDragging || _scrollView.isTracking || _scrollView.isDecelerating) {
                    return ;
                }
                [_scrollView setContentOffset:CGPointMake(CGRectGetMaxX(tmpRect)-self.bounds.size.width, 0)];
            }
            
        }

    });
    
}

- (UIImage *)_drawImageFromSamples:(SInt16 *)samples sampleCount:(NSInteger)sampleCount {
    
    // 0.返回空
    if (!sampleCount) {
        return nil;
    }
    
    NSInteger sample_count = self.sampleLineCount > 0 ? ceil(self.sampleLineCount) : sampleCount;
    
    // 1.获取画布大小
    CGSize samplesImgSize = CGSizeMake(sample_count*0.5 + 1, self.frame.size.height);
    UIGraphicsBeginImageContextWithOptions(samplesImgSize, NO, 0);
    
    // 2.获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetAlpha(context, 1.0);
    CGColorRef waveColor = self.waveColor.CGColor;
    CGContextFillRect(context, CGRectMake(0, 0, samplesImgSize.width, samplesImgSize.height));
    CGContextSetLineWidth(context, 0.5);
    
    
    // 2.绘制值
    for (int index = 0; index < sampleCount; index++) {
        int i =  self.sampleLineCount > 0 ? index%sample_count : index;
        SInt16 val = ABS(samples[index]);
        float volum  = ((val*1.0) / 65535); // 缩小到0~1的float 0xFFFF
        if (0 == volum || volum < 0.005) { // 限制最小值
            volum = 0.005;
        }
        CGFloat h = volum * samplesImgSize.height*2;
        CGFloat w = 0.5;
        NSLog(@"%hd ====== %f",val, volum);
//        NSLog(@"x : %f === y : %f w : %f ====== h : %f",w+w*i,(samplesImgSize.height-h) * 0.5 + h, w, h);
        
        CGContextMoveToPoint(context, w+w*i, (samplesImgSize.height-h) * 0.5);
        CGContextAddLineToPoint(context, w+w*i, (samplesImgSize.height-h) * 0.5 + h);
        CGContextSetStrokeColorWithColor(context, waveColor);
        CGContextStrokePath(context);
        
        if (self.needDrawHorizonLine) {
            CGContextSetLineWidth(context, 0.25);
            CGContextMoveToPoint(context, 0, samplesImgSize.height * 0.5);
            CGContextAddLineToPoint(context, samplesImgSize.width, samplesImgSize.height * 0.5);
            CGContextStrokePath(context);
        }
    }
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return newImage;
}



@end
