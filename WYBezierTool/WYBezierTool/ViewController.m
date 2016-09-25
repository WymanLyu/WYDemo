//
//  ViewController.m
//  WYBezierTool
//
//  Created by yunyao on 16/9/22.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "ViewController.h"
#import "WYCoordinateView.h"
#import "WYOperationView.h"

#define kMargin 35
#define kWindowH self.view.bounds.size.height
#define kWindowW self.view.bounds.size.width

@interface ViewController ()

/** 坐标交互区 */
@property (weak) WYCoordinateView *coordinateView;

/** 操作区 */
@property (weak) WYOperationView *operationView;

/** 结果区 */
@property (weak) NSTextField *resultTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    NSLog(@"%@", NSStringFromRect(self.view.bounds));
    
    // 1.设置子控件
    [self setupSubs];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dotViewCoordinateNoti:) name:kDotViewCoordinateNotification object:self.coordinateView];
    
    // 设置默认曲线模型
    WYBezierLineModel *bezierLine0 = [[WYBezierLineModel alloc] init];
//    WYBezierLineModel *bezierLine1 = [[WYBezierLineModel alloc] init];
//    WYBezierLineModel *bezierLine2 = [[WYBezierLineModel alloc] init];
//    WYBezierLineModel *bezierLine3 = [[WYBezierLineModel alloc] init];
    [[self.coordinateView mutableArrayValueForKey:@"bezierArrM"] addObject:bezierLine0];
//    [[self.coordinateView mutableArrayValueForKey:@"bezierArrM"] addObject:bezierLine1];
//    [[self.coordinateView mutableArrayValueForKey:@"bezierArrM"] addObject:bezierLine2];
//    [[self.coordinateView mutableArrayValueForKey:@"bezierArrM"] addObject:bezierLine3];
    
    
    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

#pragma mark - 设置子控件

- (void)setupSubs {
    
    // 1.坐标交互区
    WYCoordinateView *coordinateView = [[WYCoordinateView alloc] init];
    CGFloat coordinateW = (kWindowW - 3*kMargin)*0.5;
    CGFloat coordinateH = coordinateW;
    CGFloat coordinateX = kMargin;
    CGFloat coordinateY = kWindowH - kMargin - coordinateH;
    coordinateView.frame = CGRectMake(coordinateX, coordinateY, coordinateW,coordinateH);
    [self.view addSubview:coordinateView];
    coordinateView.wantsLayer = YES;
    coordinateView.layer.backgroundColor = [NSColor gridColor].CGColor;
    [coordinateView startAnimation];
    
    // 2.结果展示区
    NSTextField *resultTextField = [[NSTextField alloc] init];
    CGFloat resultTextFieldW = kWindowW - 2*kMargin;
    CGFloat resultTextFieldH = kWindowH - 3*kMargin - coordinateH;
    CGFloat resultTextFieldX = kMargin;
    CGFloat resultTextFieldY = kMargin;
    resultTextField.frame = CGRectMake(resultTextFieldX, resultTextFieldY, resultTextFieldW, resultTextFieldH);
    resultTextField.font = [NSFont systemFontOfSize:11.5f];
    resultTextField.textColor = [NSColor blackColor];
    [self.view addSubview:resultTextField];
    resultTextField.wantsLayer = YES;
    resultTextField.selectable = NO; // 不允许交互
    resultTextField.layer.backgroundColor = [NSColor grayColor].CGColor;
    
    // 3.操作区
    WYOperationView *operationView = [[WYOperationView alloc] init];
    CGFloat operationW = (kWindowW - 3*kMargin)*0.5;
    CGFloat operationH = coordinateW;
    CGFloat operationX = kMargin*2 + operationW;
    CGFloat operationY = kWindowH - kMargin - coordinateH;
    operationView.frame = CGRectMake(operationX, operationY, operationW, operationH);
    [self.view addSubview:operationView];
    operationView.wantsLayer = YES;
    operationView.layer.backgroundColor = [NSColor gridColor].CGColor;
    
    // 4.控制器引用子控件
    _coordinateView = coordinateView;
    _resultTextField = resultTextField;
    _operationView = operationView;    
}

- (void)dotViewCoordinateNoti:(NSNotification *)noti {
    
    NSArray *result = noti.userInfo[@"BezierEquation"];
    
    NSMutableString *resultStr = [NSMutableString string];
    for (NSString *str in result) {
        [resultStr appendString:[NSString stringWithFormat:@"%@\n\n", str]];
    }
    self.resultTextField.stringValue = resultStr;
//    [self.resultTextField setNeedsDisplay:YES];
    
}



@end
