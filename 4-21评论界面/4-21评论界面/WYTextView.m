//
//  WYTextView.m
//  4-21评论界面
//
//  Created by wyman on 2017/4/23.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYTextView.h"
#import "WYInputAccessoryToolView.h"
#import "WYTextViewDelegate.h"

#define INPUTACCESSORYTOOLVIEW_H 44

@interface WYTextView()

@property (nonatomic, weak) UIButton *maskBtn;

@property (nonatomic, assign) CGFloat oneLineH;

/** 行数 */
@property (nonatomic, assign) CGFloat maxLineNumber;

/** 文本头部行间距 */
@property (nonatomic, assign) CGFloat headerLineMargin;

/** 代理 */
@property (nonatomic, strong) WYTextViewDelegate *customDelegate;

/** 之前高度 */
@property (nonatomic, assign) CGFloat previousTextViewHeight;

@property (nonatomic, assign) CGRect originF;

@end

@implementation WYTextView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 操作条
        UIView *inputAccessoryView = [[WYInputAccessoryToolView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, INPUTACCESSORYTOOLVIEW_H)];
        inputAccessoryView.backgroundColor = [UIColor yellowColor];
        self.inputAccessoryView = inputAccessoryView;
        
        // 代理
        _customDelegate = [WYTextViewDelegate new];
        _maxLineNumber = 3;
        _originF = frame;
        _previousTextViewHeight  = 36.0f;
//        self.delegate = _customDelegate;
        
        // 通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

#pragma mark - 拦截

- (void)layoutSubviews {
    [super layoutSubviews];

    // 设置单行居中
//    UIView *view = self.subviews.firstObject;
//    if (self.text.length) {
//        return;
//    }
//    if (view.frame.size.height < self.frame.size.height) {
//        CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
//        view.center = center;
//    }
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    _oneLineH = [@"ONELINEHEIGHT" wy_getHeightInOneLineWithFont:font];
}


- (void)setContentSize:(CGSize)contentSize {
    CGSize originContentSize = self.contentSize;
    [super setContentSize:contentSize];
    
    if (contentSize.height < 36.0) {
        return;
    }
    // 1.最大高度
    CGFloat maxHeight =ceil(self.font.lineHeight * self.maxLineNumber + self.textContainerInset.top + self.textContainerInset.bottom);
    // 2.内容高度
    CGFloat contentH = [self getTextViewContentH:self];
    // 3.是否缩小
    BOOL isShrinking = contentH < self.previousTextViewHeight;
    // 4.高度差
    CGFloat changeInHeight = contentH - self.previousTextViewHeight;
    // 5.校验高度差，不能超过最大高度与当前高度的差值，且在没有文字输入/达到最大值时候 且 缩小 的情况下不变
    if (!isShrinking && (self.previousTextViewHeight == maxHeight || self.text.length == 0)) {
        changeInHeight = 0;
    } else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewHeight);
    }
    // 6.当前frame
    CGRect prevFrame = self.frame;
    if (CGRectEqualToRect(self.frame, CGRectZero)) {
        prevFrame = self.originF;
    }
    
    // 8.获取行数
    NSInteger numLines = 1;
    if (self.font) {
        numLines = (self.contentSize.height-(self.textContainerInset.top + self.textContainerInset.bottom)) / self.font.lineHeight;
        NSLog(@"~~~%f-%zd", self.font.lineHeight, numLines);
        NSLog(@"lineFragmentPadding:%f textContainerInset:%f textContainerInset:%f contentInset%f contentH:%f changeInHeight:%f",self.textContainer.lineFragmentPadding ,self.textContainerInset.top,self.textContainerInset.bottom,self.contentInset.top, contentH, changeInHeight);
    }
    self.contentInset = UIEdgeInsetsMake((numLines > self.maxLineNumber ? 8.0f : 0.0f), 0.0f, (numLines >self.maxLineNumber ? 8.0f : 0.0f), 0.0f);
    if (numLines > self.maxLineNumber) {
        CGPoint bottomOffset = CGPointMake(0.0f, contentH - self.bounds.size.height);
        [self setContentOffset:bottomOffset animated:YES];
    }
    
    // 7.缩放
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(prevFrame.origin.x, prevFrame.origin.y - changeInHeight, prevFrame.size.width, prevFrame.size.height + changeInHeight);
    }];
     self.previousTextViewHeight = MIN(contentH, maxHeight);


     // 9.记录高度
    self.previousTextViewHeight = MIN(contentH, maxHeight);
     // 10.调整内边距
//    if (numLines > 1) {
//        self.contentInset = UIEdgeInsetsMake(0.0f, 0, 0.0f, 0);
////        CGPoint bottomOffset = CGPointMake(0.0f, [self getTextViewContentH:self] -self.bounds.size.height);
////        [self setContentOffset:bottomOffset animated:YES];
//    } else {
//        self.contentInset = UIEdgeInsetsMake(8.0f, 0, 8.0f, 0);
//
//    }

//    if (numLines > self.maxLineNumber) {
//        CGPoint bottomOffset = CGPointMake(0.0f, contentH - self.bounds.size.height);
//        [self setContentOffset:bottomOffset animated:YES];
//    }

    
//    UIView *view = self.subviews.firstObject;
//    if (numLines>1 && numLines < self.maxLineNumber) {
//        self.contentInset = UIEdgeInsetsMake((numLines >=self.maxLineNumber ? 4.0f : 0.0f), 0.0f, (numLines >=self.maxLineNumber ? 4.0f : 0.0f), 0.0f);
//        CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
//        view.center = center;
////        view.frame = self.bounds;
//    } else {
//        CGPoint bottomOffset = CGPointMake(0.0f, contentH - self.bounds.size.height);
//        [self setContentOffset:bottomOffset animated:YES];
//    }
//    NSLog(@"%f--%f--%f-%f-%f-%f", contentH, view.bounds.size.height, view.frame.origin.y, prevFrame.size.height + changeInHeight, self.contentInset.top, self.contentSize.height);
    
    // 11.达到最大行数再调整
//    if (numLines > self.maxLineNumber) {
////        CGPoint bottomOffset = CGPointMake(0.0f, contentH -self.bounds.size.height);
//        CGPoint bottomOffset = CGPointMake(0.0f, contentH - self.bounds.size.height);
//        [self setContentOffset:bottomOffset animated:YES];
//        [self scrollRangeToVisible:NSMakeRange(self.text.length-2, 1)];
//    }
    // 12.刚好是最大行数时
//    if (self.previousTextViewHeight == maxHeight || numLines == self.maxLineNumber) {
//        double delayInSeconds = 0.01;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime,
//                       dispatch_get_main_queue(),
//                       ^(void) {
//                           CGPoint bottomOffset = CGPointMake(0.0f, contentH - self.bounds.size.height);
//                           [self setContentOffset:bottomOffset animated:YES];
//                       });
//    }

    
}

//static bool changeTextInset = NO;
- (void)textDidChange {
    // 获取行数
    NSInteger numLines = 1;
    if (self.font.lineHeight) {
        numLines = (self.contentSize.height-(self.textContainerInset.top + self.textContainerInset.bottom)) / self.font.lineHeight;
    }
    UIView *view = self.subviews.firstObject;
    
    
    // 居中
//    CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
//    view.center = center;
    
    if (!self.text.length) {
        return;
    }
    
//    // 根据行数调整视图
//    if (numLines > 1) {
//        NSLog(@"numLines > 1----view.frame :%@ self.contentSize.height :%f self.bounds.size.height:%f",[NSValue valueWithCGRect:view.frame], self.contentSize.height , self.bounds.size.height);
//        if (numLines <= self.maxLineNumber) {
//            CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
//            view.center = center;
//        } else {
//            CGPoint bottomOffset = CGPointMake(0.0f, [self getTextViewContentH:self] -self.bounds.size.height);
////            [self setContentOffset:bottomOffset animated:YES];
//            
//        }
//        NSLog(@"numLines > 1====view.frame :%@ self.contentSize.height :%f self.bounds.size.height:%f",[NSValue valueWithCGRect:view.frame], self.contentSize.height , self.bounds.size.height);
//    } else  {
//        NSLog(@"----view.frame :%@ self.contentSize.height :%f self.bounds.size.height:%f",[NSValue valueWithCGRect:view.frame], self.contentSize.height , self.bounds.size.height);
//        self.textContainerInset = UIEdgeInsetsMake(0, 8, 0, 8);
//         CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
//        view.center = center;
////        CGFloat marginH = self.frame.size.height - view.bounds.size.height;
////        [UIView animateWithDuration:0.25 animations:^{
////            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+marginH, self.frame.size.width, view.bounds.size.height);
////        }];
//        NSLog(@"====view.frame :%@ self.contentSize.height :%f self.bounds.size.height:%f",[NSValue valueWithCGRect:view.frame], self.contentSize.height , self.bounds.size.height);
//    }
}

- (void)setContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:contentOffset];
}

#pragma mark - 通知处理

- (void)keyboardWillChangeFrame:(NSNotification *)noti {
//    NSLog(@"%@", noti.userInfo);
    NSDictionary *userInfo = noti.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 执行动画 - 自己
    CGRect tempRect = self.frame;
    tempRect.origin.y = keyboardF.origin.y - self.frame.size.height;
    
    // 执行动画 - 当前控制器视图
    UIViewController *curentVc = [UIViewController wy_currentDisplayViewController];
    UIScrollView *animateScrollView = nil;
    CGPoint animateP = CGPointZero;
    CGRect vcTempRect = curentVc.view.frame;
    
    for (UIView *subView in curentVc.view.subviews) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            animateScrollView = (UIScrollView *)subView;
            if (keyboardF.origin.y < [UIScreen mainScreen].bounds.size.height) { // 键盘出现
                animateP = CGPointMake(animateScrollView.contentOffset.x, animateScrollView.contentOffset.y + keyboardF.size.height);
            } else {
                animateP = CGPointMake(animateScrollView.contentOffset.x, animateScrollView.contentOffset.y - keyboardF.size.height);
            }
            break;
        }
    }
    if (!animateScrollView) {
        if (keyboardF.origin.y < [UIScreen mainScreen].bounds.size.height) { // 键盘出现
            vcTempRect.origin.y = vcTempRect.origin.y - keyboardF.size.height;
        } else {
            vcTempRect.origin.y = vcTempRect.origin.y + keyboardF.size.height;
        }
    }
    
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (animateScrollView) {
            [animateScrollView setContentOffset:animateP];
             self.frame = tempRect;
        } else {
            curentVc.view.frame = vcTempRect;
        }
    }];
    
}

- (void)textDidEndEditing:(NSNotification *)noti {
    if (self.maskBtn) {
        [self maskBtnClick:self.maskBtn];
    }
}

- (void)textDidBeginEditing:(NSNotification *)noti {
    UIButton *maskBtn = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [maskBtn addTarget:self action:@selector(maskBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:maskBtn];
    self.maskBtn = maskBtn;
    
   
    
}

- (void)maskBtnClick:(UIButton *)maskBtn {
    [maskBtn removeFromSuperview];
    self.maskBtn = nil;
    [self endEditing:YES];
}

- (CGFloat)getTextViewContentH:(UITextView *)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}





@end
