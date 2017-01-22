//
//  ViewController.m
//  11-16Animation
//
//  Created by yunyao on 2016/11/16.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

/** 上半部图片 */
@property (nonatomic, weak) UIImageView *topImgView;

/** 下半部图片 */
@property (nonatomic, weak) UIImageView *bottomImgView;

/** 容器视图 */
@property (nonatomic, weak) UIView *containView;

/** 渐变层 */
@property (nonatomic, weak) CAGradientLayer *gradientLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 像素偏移
    CGFloat offset = 0.25;
    UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    [self.view addSubview:containView];
    containView.center = self.view.center;
    self.containView.backgroundColor = [UIColor redColor];
    self.view.backgroundColor = [UIColor brownColor];
    self.containView = containView;
    
    UIImageView *topImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 125.5)];
    topImgView.image = [UIImage imageNamed:@"知道错了"];
    [containView addSubview:topImgView];
    // 让锚点在layer的下边中点
    topImgView.layer.anchorPoint = CGPointMake(0.5, 1);
    // 让layer在父控件的上半部
    topImgView.layer.position = CGPointMake(125.5, 125.5 + offset);
    // 截取layer的内容上半部
    topImgView.layer.contentsRect = CGRectMake(0, 0, 1, 0.5);
    // 内容模式为等比例
    topImgView.layer.contentsGravity = @"resizeAspect";
    
    UIImageView *bottomImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 125.5)];
    bottomImgView.image = [UIImage imageNamed:@"知道错了"];
    [containView addSubview:bottomImgView];
    // 让锚点在layer的上边中点
    bottomImgView.layer.anchorPoint = CGPointMake(0.5, 0);
    // 让layer在父控件的下半部
    bottomImgView.layer.position = CGPointMake(125.5, 125.5 - offset);
    // 截取layer的内容下半部
    bottomImgView.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.5);
    // 内容模式为等比例
    bottomImgView.layer.contentsGravity = @"resizeAspect";
    
    self.topImgView = topImgView;
    self.bottomImgView = bottomImgView;
    
    // 添加手势
    containView.userInteractionEnabled = YES;
    [containView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];

    
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    
    static CATransform3D transform = {1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1};
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        transform = self.topImgView.layer.transform;
        NSLog(@"====%@",[NSValue valueWithCATransform3D:transform]);
        // 添加阴影
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor];
        // 默认0开始是第一个颜色，到0.1开始渐变，变到0.9结束，0.9到1时黑色
        gradientLayer.locations = @[@0.1, @0.9];
        gradientLayer.frame = self.topImgView.layer.bounds;
        gradientLayer.opacity = 0;
        [self.bottomImgView.layer addSublayer:gradientLayer];
        self.gradientLayer = gradientLayer;
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        NSLog(@"移动");
        
        // 1.获取相对于最初手指的移动差值
        CGPoint transtionPoint = [pan translationInView:self.containView];
        // 2.计算偏移量
        CGFloat offsetScale = transtionPoint.y / 250;
        // 3.做绕x旋转动画
        CGFloat angle = offsetScale*M_PI;
        NSLog(@"offsetScale:%f",  transtionPoint.y);
        transform = CATransform3DIdentity;
        transform.m34 = -1/400.0;
        self.topImgView.layer.transform = CATransform3DRotate(transform, -angle, 1, 0, 0);
        self.gradientLayer.opacity = offsetScale;
        
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        NSLog(@"结束");
        // damping 越小越弹
        // velocity 初始速度
        [UIView animateWithDuration:0.35 delay:0.01f usingSpringWithDamping:0.1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.topImgView.layer.transform = CATransform3DIdentity;
            self.gradientLayer.opacity = 0;
        } completion:nil];
      
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
