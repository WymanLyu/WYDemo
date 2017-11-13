//
//  ScoreRotateView.m
//  11-12滚动数字
//
//  Created by wyman on 2017/11/12.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ScoreRotateView.h"

#define ERROR_ADD_ANGLE -1

#define MIN_BPM 50
#define MAX_BPM 160

#define MIN_ANGLE_NEGATIVE (-270)
#define MAX_ANGLE_NEGATIVE (0)

#define MIN_ANGLE_POSITIVE (90)
#define MAX_ANGLE_POSITIVE (360)

@interface ScoreRotateView ()

@property (nonatomic, strong) UIImageView *scoreImgView;

@property (nonatomic, strong) UIImageView *pointerImgView;

@property(nonatomic,strong) UIPanGestureRecognizer *pan;

@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, assign) CGPoint contentCenterPoint; // 旋转的弧度
@property (nonatomic, assign) CGFloat rotationAngleInRadians; // 旋转的弧度
@property (nonatomic, assign) CGFloat lastCurrentAngleInRadians; // 用于记录是否顺时针或逆时针

@property (nonatomic, assign) NSInteger currentScore;

@end

@implementation ScoreRotateView
{
    CADisplayLink *dis; // 定时器
    int updateCount; //
    int currentCount;
    CGPoint velocity;

}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.scoreImgView = [[UIImageView alloc] init];
        self.scoreImgView.image = [UIImage imageNamed:@"scale_big"];
        [self addSubview:self.scoreImgView];
        self.scoreImgView.userInteractionEnabled = YES;
        self.scoreImgView.frame = self.bounds;
        self.scoreImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        
        self.pointerImgView = [[UIImageView alloc] init];
        [self addSubview:self.pointerImgView];
        self.pointerImgView.frame = CGRectMake(0, 104, 24, 21);
        self.pointerImgView.image = [UIImage imageNamed:@"pointer"];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(paned:)];
        [self addGestureRecognizer:pan];
        self.pan = pan;
        self.contentCenterPoint = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    }
    return self;
}

static BOOL pass = NO;
- (void)paned:(UIPanGestureRecognizer *)pan {
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        self.startPoint = [pan locationInView:self];
        CGPoint startPointInUpDown = [self convertPoint:self.startPoint toUpDownCoordinateCenter:self.contentCenterPoint];
        self.lastCurrentAngleInRadians = atan2(startPointInUpDown.y, startPointInUpDown.x);
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        
        CGFloat addAngle = [self caculateCurrentAddAngle:pan];
        if (addAngle==ERROR_ADD_ANGLE) return;
        CGFloat scrollAgree = fmodf(addAngle + self.rotationAngleInRadians, M_PI*2) * 180/M_PI;
        if ((scrollAgree >=-270 && scrollAgree<=0) || (scrollAgree>=90 && scrollAgree<=360)) {
            // 旋转角度+已有角度
            [self rotateBPMWithScrollAngle:scrollAgree];
            pass = NO;
            self.scoreImgView.transform = CGAffineTransformMakeRotation(fmodf(addAngle + self.rotationAngleInRadians, M_PI*2));

        } else {
            if (pass==NO) {
                // 跨入临界值，记录当前角度并对齐到临界点
                [self rotateEndBPMWithScrollAngle:scrollAgree];
            }
            pass = YES;
        }
    } else {
        if (pass) return;
        CGFloat addAngle = [self caculateEndAddAngle:pan];
        self.rotationAngleInRadians = fmodf(addAngle + self.rotationAngleInRadians, M_PI*2);
    }
    
}


/** 转换坐标系 */
- (CGPoint)convertPoint:(CGPoint)point toUpDownCoordinateCenter:(CGPoint)centerPoint {
    return CGPointMake(point.x-centerPoint.x, centerPoint.y-point.y);
}

/** 计算手势中当前增量 */
- (CGFloat)caculateCurrentAddAngle:(UIPanGestureRecognizer *)pan {
    CGPoint currentPoint = [pan locationInView:self];
    CGPoint currentPointInUpDown = [self convertPoint:currentPoint toUpDownCoordinateCenter:self.contentCenterPoint];
    CGPoint startPointInUpDown = [self convertPoint:self.startPoint toUpDownCoordinateCenter:self.contentCenterPoint];
    CGFloat currentAngleInRadians = atan2(currentPointInUpDown.y, currentPointInUpDown.x);
    CGFloat startAngleInRadians = atan2(startPointInUpDown.y, startPointInUpDown.x);
    // 计算旋转角度
    CGFloat addAngle = startAngleInRadians-currentAngleInRadians;
    if (currentAngleInRadians-self.lastCurrentAngleInRadians < 0) { // 调整角度正负差数
        // 顺时针
        // 同一象限时导致
        if (addAngle<0) {
            addAngle = 2*M_PI+addAngle;
        }
    } else if (currentAngleInRadians-self.lastCurrentAngleInRadians > 0) {
        // 逆时针
        // 同一象限时导致
        if (addAngle>0) {
            addAngle = -2*M_PI+addAngle;
        }
    } else {
        self.lastCurrentAngleInRadians = currentAngleInRadians;
        pass = YES;
        return ERROR_ADD_ANGLE;
    }
    self.lastCurrentAngleInRadians = currentAngleInRadians;
    return addAngle;
}

/** 计算手势结束增量 */
- (CGFloat)caculateEndAddAngle:(UIPanGestureRecognizer *)pan {
    CGPoint endPoint = [pan locationInView:self];
    CGPoint endPointInUpDown = [self convertPoint:endPoint toUpDownCoordinateCenter:self.contentCenterPoint];
    CGPoint startPointInUpDown = [self convertPoint:self.startPoint toUpDownCoordinateCenter:self.contentCenterPoint];
    CGFloat endAngleInRadians = atan2(endPointInUpDown.y, endPointInUpDown.x);
    CGFloat startAngleInRadians = atan2(startPointInUpDown.y, startPointInUpDown.x);
    CGFloat addAngle = startAngleInRadians-endAngleInRadians;
    if (endAngleInRadians-self.lastCurrentAngleInRadians < 0) { // 调整角度正负差数
        // 同一象限时导致
        if (addAngle<0) {
            addAngle = 2*M_PI+addAngle;
        }
    } else {
        // 逆时针
        // 同一象限时导致
        if (addAngle>0) {
            addAngle = -2*M_PI+addAngle;
        }
    }
    return addAngle;
}

/** 旋转后的BPM */
- (void)rotateBPMWithScrollAngle:(CGFloat)scrollAngle {
    // 旋转角度+已有角度
    if (scrollAngle >=MIN_ANGLE_NEGATIVE && scrollAngle<=0) {
        CGFloat scale = 1- ((scrollAngle-(MIN_ANGLE_NEGATIVE)) / 270.0);
        NSInteger bpm = ceil((MAX_BPM-MIN_BPM)*scale+MIN_BPM);
        self.currentScore= bpm;
        
    } else  {
        CGFloat scale = 1-(scrollAngle-(MIN_ANGLE_POSITIVE)) / 270.0;
        NSInteger bpm = ceil((MAX_BPM-MIN_BPM)*scale+MIN_BPM);
        self.currentScore= bpm;
    }
}

- (void)rotateEndBPMWithScrollAngle:(CGFloat)scrollAngle {
    // 跨入临界值，记录...
    if (fabs(scrollAngle-(MIN_ANGLE_NEGATIVE)) < fabs(scrollAngle)) {
        self.rotationAngleInRadians = fmodf((MIN_ANGLE_NEGATIVE*M_PI) / 180, M_PI*2);
        self.scoreImgView.transform = CGAffineTransformMakeRotation(self.rotationAngleInRadians);
        NSInteger bpm = MAX_BPM;
        self.currentScore= bpm;
    } else {
        self.rotationAngleInRadians = 0;
        self.scoreImgView.transform = CGAffineTransformMakeRotation(self.rotationAngleInRadians);
        NSInteger bpm = MIN_BPM;
        self.currentScore= bpm;
    }
}

- (void)setCurrentScore:(NSInteger)currentScore {
    if (currentScore!=_currentScore) {
        if ([self.delegate respondsToSelector:@selector(scoreRotateView:scoreChange:)]) {
            [self.delegate scoreRotateView:self scoreChange:currentScore];
        }
    }
    _currentScore = currentScore;
}

- (void)setScore:(NSInteger)score {
    CGFloat scale = ((score-MIN_BPM)*1.0)/(MAX_BPM-MIN_BPM);//(score*1.0 / (-MIN_ANGLE_NEGATIVE));
    CGFloat angle = MIN_ANGLE_NEGATIVE * scale;
    self.rotationAngleInRadians = (angle*M_PI) / 180;
    [UIView animateWithDuration:0.25 animations:^{
        self.scoreImgView.transform = CGAffineTransformMakeRotation(self.rotationAngleInRadians);
    }];
}

- (NSInteger)score {
    return _currentScore;
}




@end
