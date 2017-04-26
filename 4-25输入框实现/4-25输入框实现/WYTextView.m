//
//  WYTextView.m
//  4-25输入框实现
//
//  Created by wyman on 2017/4/25.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYTextView.h"
#import "UIViewController+WY.h"

@interface WYTextView ()

/** 蒙版 */
@property (nonatomic, weak) UIButton *maskBtn;

@end

@implementation WYTextView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        // 默认值
        self.font = [UIFont systemFontOfSize:16.f];
        self.textColor = [UIColor blackColor];
        self.returnKeyType = UIReturnKeySend;
        self.enablesReturnKeyAutomatically = YES;
        self.previousTextViewHeight = 36;
        _maxLineNumber = 3;
        _autoFixVcViewHeight = YES;
        
        // 工具条
        WYInputAccessoryToolView *inputAccessoryToolView = [[WYInputAccessoryToolView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        inputAccessoryToolView.backgroundColor = [UIColor yellowColor];
        self.inputAccessoryView = inputAccessoryToolView;
        
        // 通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:self];

    }
    return self;
}

- (void)setContentSize:(CGSize)contentSize {
    [super setContentSize:contentSize];
    [self layoutAndAnimateTextView];
}


#pragma mark - 高度计算逻辑

- (CGFloat)getTextViewContentH:(WYTextView *)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

- (void)layoutAndAnimateTextView {

    CGFloat maxHeight = ceil(self.font.lineHeight * self.maxLineNumber+ self.textContainerInset.top);
    CGFloat contentH = [self getTextViewContentH:self];
    
    BOOL isShrinking = contentH < self.previousTextViewHeight;
    CGFloat changeInHeight = contentH - self.previousTextViewHeight;
    if (!isShrinking && (self.previousTextViewHeight == maxHeight || self.text.length == 0)) {
        changeInHeight = 0;
    } else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewHeight);
    }
    
    if (changeInHeight != 0.0f) {
        if (self.followContentChange) {
            self.followContentChange(changeInHeight, 0.15);
            [self adjustTextViewHeightBy:changeInHeight]; // 这里进行调整是为了在换行是有类似微信的滚动效果，不调用则类似qq的闪动换行
        } else {
            [UIView animateWithDuration:0.15f
                             animations:^{
                                 [self adjustTextViewHeightBy:changeInHeight];
                             }];
        }
        self.previousTextViewHeight = MIN(contentH, maxHeight);
    }
    
    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (self.previousTextViewHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f, contentH - self.bounds.size.height);
                           [self setContentOffset:bottomOffset animated:YES];
                       });
    }
}

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight
{
    //动态改变自身的高度和输入框的高度
    CGRect prevFrame = self.frame;

    NSInteger numLines = 1;
    if (self.font) {
        numLines = (self.contentSize.height-(self.textContainerInset.top + self.textContainerInset.bottom)) / self.font.lineHeight;
    }
    if (!self.followContentChange) { // 外界调整时则不处理
        self.frame = CGRectMake(prevFrame.origin.x, prevFrame.origin.y - changeInHeight, prevFrame.size.width, prevFrame.size.height + changeInHeight);
    }
    
    self.contentInset = UIEdgeInsetsMake((numLines >=self.maxLineNumber ? 4.0f : 0.0f), 0.0f, (numLines >=self.maxLineNumber ? 4.0f : 0.0f), 0.0f);
    
    // from iOS 7, the content size will be accurate only if the scrolling is enabled.
    //self.messageInputTextView.scrollEnabled = YES;
    if (numLines >=self.maxLineNumber) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.contentSize.height-self.bounds.size.height);
        [self setContentOffset:bottomOffset animated:NO];
        [self scrollRangeToVisible:NSMakeRange(self.text.length-2, 1)];
    }
}

#pragma mark - 通知处理

- (void)keyboardWillChangeFrame:(NSNotification *)noti {
    //    NSLog(@"%@", noti.userInfo);
    NSDictionary *userInfo = noti.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
     CGRect keyboardBeginF = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
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
            // 解决：#warning 这里有个bug 就是切换键盘类型时候也会触发 所以此处要判断键盘是否调整，通过keyboard的y差值来决定便宜 而不是键盘高度
            CGFloat ani = keyboardBeginF.origin.y - keyboardF.origin.y;
            animateP = CGPointMake(animateScrollView.contentOffset.x, animateScrollView.contentOffset.y + ani);
//            if (keyboardF.origin.y < [UIScreen mainScreen].bounds.size.height) { // 键盘出现
//                animateP = CGPointMake(animateScrollView.contentOffset.x, animateScrollView.contentOffset.y + keyboardF.size.height);
//            } else {
//                animateP = CGPointMake(animateScrollView.contentOffset.x, animateScrollView.contentOffset.y - keyboardF.size.height);
//            }
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
    
    if (self.followKeyBoardChange) {
        self.followKeyBoardChange(keyboardF.origin.y, duration);
    } else {
        [UIView animateWithDuration:duration animations:^{
            self.frame = tempRect;
        }];
    }
    if (self.autoFixVcViewHeight) {// 自动调整控制器高度
        [UIView animateWithDuration:duration animations:^{
            // 工具条的Y值 == 键盘的Y值 - 工具条的高度
            if (animateScrollView) {
                [animateScrollView setContentOffset:animateP];
            } else {
                curentVc.view.frame = vcTempRect;
            }
        }];
    }
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





@end
