//
//  ViewController.m
//  1-9卡片demo
//
//  Created by wyman on 2017/1/9.
//  Copyright © 2017年 tykj. All rights reserved.
//

// 最小图的尺寸
#define VIEWWIDTH 250
#define VIEWHEIGHT 300
#define VIEWALPHA  0.5

// 变化梯度
#define VIEWALPHA_DELTA 0.25

// 动画时间
#define FRAMETIME 0.5f
#define ANIMATIONTIME 0.5001f


/**
 *
 * 默认加载三个视图，只有最前面的视图展示歌曲信息。操作如下：
 *
 * 1.拖动离开的瞬间：
 *      1> 增加一个视图在最后面，展示下一首歌的信息 -> viewArray.count++
 *      2> 除了新添加的视图，其余视图做一个往前递进的动效
 *
 * 2.拖动后放手的瞬间：
 *      1> 超过临界值：
 *          1. 移动当前视图到对应角落消失
 *          2. 从父控件、数组中移除视图 -> viewArray.count--
 *
 *      2> 未超过临界值：
 *          1. 除了当前视图，其余视图做一个往后退的动效
 *          2. 移除最后面的视图
 *          3. 将当前视图做一个移动到最前面去的动效
 *
 */

#import "ViewController.h"

// 计算两点间距离
CGFloat distanceBetweenPoints (CGPoint first, CGPoint second) {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY );
};


@interface ViewController (Initilize)

@end


@interface ViewController ()

/** 缓存视图 */
@property (strong, nonatomic) NSMutableArray *viewArray;

/** 歌曲模型 */
@property (nonatomic, strong) NSMutableArray *songsArray;

/** 底部视图 */
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation ViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化视图
//    [self initView];
    //
    self.bottomView = [UIView new];
    CGFloat x = 0;
    CGFloat h = 240;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat y =  [UIScreen mainScreen].bounds.size.height;
    self.bottomView.frame = CGRectMake(x, y, w, h);
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    
    //
    for (int i = 0; i < 3; i++) {
        [self initSingeViewFromBack:YES];
    }
    [self setLastViewModelIndex:self.viewArray.count-1 withModel:[NSObject new]];
    self.view.backgroundColor = [UIColor grayColor];

    
}

#pragma mark - 懒加载
- (NSMutableArray *)viewArray {
    if (!_viewArray) {
        _viewArray = [NSMutableArray array];
    }
    return _viewArray;
}

- (NSMutableArray *)songsArray {
    if (!_songsArray) {
        _songsArray = [NSMutableArray array];
    }
    return _songsArray;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
////        [self initView];
//        for (int i = 0; i < self.viewArray.count; i++) {
//            UIView *view = self.viewArray[i];
//            CGRect frame = CGRectMake(0, 0, VIEWWIDTH + i*15, VIEWHEIGHT);
//            CGPoint center = CGPointMake(self.view.center.x, self.view.center.y + i*10);
//            [self setAlpha:VIEWALPHA + i*VIEWALPHA_DELTA view:view duration:FRAMETIME completion:nil];
//            [self setFrame:frame view:view duration:FRAMETIME completion:nil];
//            [self setPosition:center view:view duration:FRAMETIME completion:nil];
//        }
//
//        
//        [UIView animateWithDuration:FRAMETIME-0.1 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            CGFloat x = 0;
//            CGFloat h = 240;
//            CGFloat w = [UIScreen mainScreen].bounds.size.width;
//            CGFloat y =  [UIScreen mainScreen].bounds.size.height - h;
//            self.bottomView.frame = CGRectMake(x, y, w, h);
//
//        } completion:nil];
//        
//
//    });
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = [UIColor yellowColor];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    nav.navigationBar.layer.opacity= 0.1;
//    nav.navigationBar.translucent = YES;
    //    导航栏变为透明
    [nav.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    //    让黑线消失的方法
    nav.navigationBar.shadowImage=[UIImage new];
    
    
    
//    nav.navigationBar.barTintColor = [UIColor clearColor];// [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [self presentViewController:nav animated:YES completion:nil];

}

#pragma mark -  初始化多个视图
- (void)initView{
    for (int i = 0; i<3; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEWWIDTH+i*15, VIEWHEIGHT)];
        view.center = CGPointMake(self.view.center.x, self.view.center.y+i*10);
        view.alpha = VIEWALPHA + i*VIEWALPHA_DELTA;
        view.backgroundColor = [UIColor whiteColor];//  [self randomColor];
        [self.view addSubview:view];
        [self.viewArray addObject:view];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewPanHandle:)];
        [view addGestureRecognizer:panGesture];
    }
}

//  初始化一个视图,isFromBack:YES 则从后面生成，NO则从前面生成
- (void)initSingeViewFromBack:(BOOL)isFromBack{
    
    if (isFromBack) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT)];
        view.center = self.view.center;
        view.backgroundColor = [UIColor whiteColor];// [self randomColor];
        view.alpha = VIEWALPHA;
        [self.view addSubview:view];
        [self.view insertSubview:view belowSubview:(UIView*)[self.viewArray firstObject]];
        [self.viewArray insertObject:view atIndex:0];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewPanHandle:)];
        [view addGestureRecognizer:panGesture];
    }else{
        
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEWWIDTH+(self.viewArray.count - 1) *15, VIEWHEIGHT)];
//        view.center = CGPointMake(self.isFromLeft?0:self.view.bounds.size.width, self.beganPoint.y);
//        view.backgroundColor = [self randomColor];
//        view.alpha = 0;
//        [self.view addSubview:view];
//        [self.view insertSubview:view aboveSubview:(UIView*)[self.viewArray lastObject]];
//        [self.viewArray addObject:view];
//        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewPanHandle:)];
//        [view addGestureRecognizer:panGesture];
    }
    
    
    
}


- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

#pragma mark - 手势处理
- (void)viewPanHandle:(UIPanGestureRecognizer *)panGesture {
    // 1.移动顶部视图
    CGPoint point = [panGesture translationInView:self.view];
    [panGesture setTranslation:CGPointZero inView:self.view];
    UIView *view = (UIView *)[self.viewArray lastObject];
    view.center = CGPointMake(view.center.x + point.x, view.center.y + point.y);
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        // 拖动离开的瞬间
        // 从后面新建一个最小的视图
        [self initSingeViewFromBack:YES];
        // 设置
        [self setLastViewModelIndex:self.viewArray.count-2 withModel:[NSObject new]];
        // 除了新添加的视图，其余视图做一个整体往前递进的一个动画
        [self changeViewFrameForward:YES];
    } else if (panGesture.state == UIGestureRecognizerStateChanged) {

    } else if (panGesture.state == UIGestureRecognizerStateEnded) {
        // 拖动后放手的瞬间 以x是否距离中心点0.25*w为临界点，所以垂直方向效果不好（用圆形的话，水平方向效果不好）
        if (fabs(view.center.x - self.view.center.x) > self.view.center.x/2) { // 超过临界值，则消失
            //  分区坐标进行消失动画
            //               ^
            //               |
            //               |
            //     leftTop   |  rightTop
            //  ------------------------------- 0.4*h == scale*h
            //               |
            //               |
            //  ----left-----*----right---------->
            //               |
            //               |
            //  ------------------------------- 0.6*h
            //               |
            //   leftBottom  |  rightBottom
            //               |
            //               |
            //
            CGFloat scale = 0.35; // 0-0.5
            CGFloat externRect = self.view.bounds.size.width; // 针对上下左右的拓展区域（不然拖太出去，center为负数也不在区间内）
            CGPoint targetP = CGPointZero;
            CGFloat animateDuration = 0.2;
            
            CGRect leftTop = CGRectMake(-externRect, -externRect, self.view.bounds.size.width*0.5+externRect, self.view.bounds.size.height*scale+externRect);
            CGRect rightTop = CGRectMake(self.view.center.x, -externRect, self.view.bounds.size.width*0.5+externRect, self.view.bounds.size.height*scale+externRect);
            CGRect leftBottom = CGRectMake(-externRect, self.view.bounds.size.height*(1-scale), self.view.bounds.size.width*0.5+externRect, self.view.bounds.size.height*scale+externRect);
            CGRect rightBottom = CGRectMake(self.view.center.x, self.view.bounds.size.height*(1-scale), self.view.bounds.size.width*0.5+externRect, self.view.bounds.size.height*scale+externRect);
            
            CGRect left = CGRectMake(-externRect, self.view.bounds.size.height*scale, self.view.bounds.size.width*0.5+externRect, self.view.bounds.size.height*(1-2*scale));
            CGRect right = CGRectMake(self.view.center.x, self.view.bounds.size.height*scale, self.view.bounds.size.width*0.5+externRect, self.view.bounds.size.height*(1-2*scale));
            
            if (CGRectContainsPoint(leftTop, view.center)) { // 左上
                targetP = CGPointMake(0, 0);
            } else if (CGRectContainsPoint(rightTop, view.center)) { // 右上
                targetP = CGPointMake(self.view.bounds.size.width, 0);
            } else if (CGRectContainsPoint(leftBottom, view.center)) { // 左下
                targetP = CGPointMake(0, self.view.bounds.size.height);
            } else if (CGRectContainsPoint(rightBottom, view.center)) { // 右下
                targetP = CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height);
            } else if (CGRectContainsPoint(left, view.center)) { // 左边
                targetP = CGPointMake(0, view.center.y);
                animateDuration = animateDuration*0.5;
            } else if (CGRectContainsPoint(right, view.center)) { // 右边
                targetP = CGPointMake(self.view.bounds.size.width, view.center.y);
                animateDuration = animateDuration*0.5;
            } else {
                goto back;
            }

            [UIView animateWithDuration:animateDuration animations:^{
//                view.alpha = 0.4;
                view.bounds = CGRectMake(0, 0, view.bounds.size.width*1, view.bounds.size.height*1);
                view.center = targetP;
            }completion:^(BOOL finished) {
                [view removeFromSuperview];
                [self.viewArray removeLastObject];
            }];
            
        } else{ // 没有超过临界值则回去
        back:
            // 回去的动画
            [self setPosition:CGPointMake(self.view.center.x, self.view.center.y+(self.viewArray.count - 2)*10) view:view duration:ANIMATIONTIME completion:nil];
            // 整体向后的动画
            [self changeViewFrameForward:NO];

        }
    }
}

#pragma mark - 卡片整体移动

//  改变所有视图位置和大小,isForward
- (void)changeViewFrameForward:(BOOL)isForward{
    if (isForward) { // 向前的动画
        // 除了第一张（最后那张小的）,其余向前递进, count=4, view=>index=0,1,2,3
        for (int i = 1; i < (self.viewArray.count-1); i++) {
            UIView *view = self.viewArray[i];
            CGRect frame = CGRectMake(0, 0, VIEWWIDTH + i*15, VIEWHEIGHT);
            CGPoint center = CGPointMake(self.view.center.x, self.view.center.y + i*10);
            [self setAlpha:VIEWALPHA + i*VIEWALPHA_DELTA view:view duration:FRAMETIME completion:nil];
            [self setFrame:frame view:view duration:FRAMETIME completion:nil];
            [self setPosition:center view:view duration:FRAMETIME completion:nil];
        }
    } else { // 向后的动画
        // 除了最尾一张（前面那张大的），其余向后退, count=4, view=>index=0,1,2
        for (int i = 0; i< (self.viewArray.count-1); i++) {
            // 取出倒数第二张，变成第一张的效果；倒数第三张变成倒数第二张的效果... 索引1->0,2->1,3->2
            UIView *view = self.viewArray[i+1];
            CGRect frame = CGRectMake(0, 0, VIEWWIDTH + i*15, VIEWHEIGHT);
            CGPoint center = CGPointMake(self.view.center.x, self.view.center.y + i*10);
             __weak typeof(self)weakSelf = self;
            if (i == 2) { // 最前面那个再向后移动完毕 则移除底部那个
                [self setFrame:frame view:view duration:FRAMETIME completion:^(BOOL finished) {
                    // 设置为白色，但实际上不知为什么写在其他回调会马上执行（这是个巨坑啊！！写在透明度动画回调为何不行！！）
                    [weakSelf setLastViewModelIndex:2 withModel:nil];
                    // 移除底部那个视图
                    [(UIView *)[weakSelf.viewArray firstObject] removeFromSuperview];
                    [weakSelf.viewArray removeObjectAtIndex:0];
                    
                }];
              
            } else {
                [self setFrame:frame view:view duration:FRAMETIME completion:nil];
            }
            [self setAlpha:VIEWALPHA + i*VIEWALPHA_DELTA view:view duration:ANIMATIONTIME completion:nil];
            [self setPosition:center view:view duration:FRAMETIME completion:nil];
        }
    }
}

// 改变卡牌透明度的动画
- (void)setAlpha:(CGFloat)alpha view:(UIView*)view duration:(float)time completion:(void (^ __nullable)(BOOL finished))completion {
    [UIView animateWithDuration:time animations:^{
        view.alpha = alpha;
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}

// 改变卡片位置的动画
- (void)setPosition:(CGPoint)position view:(UIView*)view duration:(float)time completion:(void (^ __nullable)(BOOL finished))completion {
    [UIView animateWithDuration:time animations:^{
        view.center = position;
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}

//  动画改变卡片大小
- (void)setFrame:(CGRect)frame view:(UIView*)view duration:(float)time completion:(void (^ __nullable)(BOOL finished))completion{
    [UIView animateWithDuration:time animations:^{
        view.frame = frame;
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}

// 设置index的模型
- (void)setLastViewModelIndex:(NSInteger)index withModel:(id)model {
    UIView *forwardView = [self.viewArray objectAtIndex:index];
    if (model) {
        forwardView.backgroundColor = [self randomColor];
    } else {
        forwardView.backgroundColor = [UIColor whiteColor];
    }
}


@end
