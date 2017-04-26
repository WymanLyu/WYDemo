//
//  WYTextView2.m
//  4-21评论界面
//
//  Created by wyman on 2017/4/25.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYTextView2.h"

@interface WYTextView2 ()

@property CGFloat previousTextViewHeight;

@property (nonatomic, weak) UIButton *maskBtn;

@end

@implementation WYTextView2

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 操作条
//        UIView *inputAccessoryView = [[WYInputAccessoryToolView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, INPUTACCESSORYTOOLVIEW_H)];
//        inputAccessoryView.backgroundColor = [UIColor yellowColor];
//        self.inputAccessoryView = inputAccessoryView;
        
        
        // 通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:self];
        
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}



- (void)setContentSize:(CGSize)contentSize {
    [super setContentSize:contentSize];
    [self layoutAndAnimateTextView:self];
}

#pragma mark -WYTextView2 方法
- (NSUInteger)numberOfLinesOfText{
    return [WYTextView2 numberOfLinesForMessage:self.text];
}

+ (NSUInteger)maxCharactersPerLine{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)? 33:109;
}

+ (NSUInteger)numberOfLinesForMessage:(NSString *)text{
    return (text.length / [WYTextView2 maxCharactersPerLine]) + 1;
}


#pragma mark -- 计算textViewContentSize改变

- (CGFloat)getTextViewContentH:(WYTextView2 *)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

- (CGFloat)fontWidth
{
    return 36.f; //16号字体
}

- (CGFloat)maxLines
{
    CGFloat h = [[UIScreen mainScreen] bounds].size.height;
    CGFloat line = 5;
    if (h == 480) {
        line = 3;
    }else if (h == 568){
        line = 3.5;
    }else if (h == 667){
        line = 4;
    }else if (h == 736){
        line = 4.5;
    }
    return line;
}

- (void)layoutAndAnimateTextView:(WYTextView2 *)textView
{
    CGFloat maxHeight = ceil(self.font.lineHeight * 3 + self.textContainerInset.top + self.textContainerInset.bottom); // [self fontWidth] * [self maxLines];
    CGFloat contentH = [self getTextViewContentH:textView];
    
    BOOL isShrinking = contentH < self.previousTextViewHeight;
    CGFloat changeInHeight = contentH - self.previousTextViewHeight;
    
    if (!isShrinking && (self.previousTextViewHeight == maxHeight || textView.text.length == 0)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewHeight);
    }
    
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             if (isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewHeight = MIN(contentH, maxHeight);
                                 }
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self adjustTextViewHeightBy:changeInHeight];
                             }
                             CGRect inputViewFrame = self.frame;
                             self.frame = CGRectMake(0.0f,
                                                     inputViewFrame.origin.y - changeInHeight,
                                                     inputViewFrame.size.width,
                                                     (inputViewFrame.size.height + changeInHeight));
                             if (!isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewHeight = MIN(contentH, maxHeight);
                                 }
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [self adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
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
                           CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }
}

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight
{
    //动态改变自身的高度和输入框的高度
    CGRect prevFrame = self.frame;
    if (CGRectEqualToRect(self.frame, CGRectZero)) {
        prevFrame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-464, [UIScreen mainScreen].bounds.size.width*0.5, 36);
    }
    
//    NSUInteger numLines = MAX([self numberOfLinesOfText],
//                              [[self.text componentsSeparatedByString:@"\n"] count] + 1);
    NSInteger numLines = 1;
    if (self.font.lineHeight) {
        numLines = (self.contentSize.height-(self.textContainerInset.top + self.textContainerInset.bottom)) / self.font.lineHeight;
    }

    
    
    self.frame = CGRectMake(prevFrame.origin.x, prevFrame.origin.y, prevFrame.size.width, prevFrame.size.height + changeInHeight);
    
    self.contentInset = UIEdgeInsetsMake((numLines >=6 ? 4.0f : 0.0f), 0.0f, (numLines >=6 ? 4.0f : 0.0f), 0.0f);
    
    // from iOS 7, the content size will be accurate only if the scrolling is enabled.
    //self.messageInputTextView.scrollEnabled = YES;
    if (numLines >=6) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.contentSize.height-self.bounds.size.height);
        [self setContentOffset:bottomOffset animated:YES];
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



@end
