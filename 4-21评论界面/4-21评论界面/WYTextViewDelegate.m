//
//  WYTextViewDelegate.m
//  4-21评论界面
//
//  Created by wyman on 2017/4/24.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYTextViewDelegate.h"

@implementation WYTextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    UIView *view = textView.subviews.firstObject;
    if (view.frame.size.height < textView.frame.size.height) {
        CGPoint center = CGPointMake(textView.frame.size.width * 0.5, textView.frame.size.height * 0.5);
        view.center = center;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
//    if (textView.text.length > 0) {
//        self.placeHolderLabel.hidden = YES;
//    } else {
//        self.placeHolderLabel.hidden = NO;
//    }
    
//    UIView *view = textView.subviews.firstObject;
//    if (view.frame.size.height < textView.frame.size.height) {
//        CGPoint center = CGPointMake(textView.frame.size.width * 0.5, textView.frame.size.height * 0.5);
//        view.center = center;
//    } else {
//        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
//    }
    CGFloat maxHeight =ceil(textView.font.lineHeight * 3 + textView.textContainerInset.top + textView.textContainerInset.bottom);
    
    CGFloat height = ceil([textView sizeThatFits:CGSizeMake(textView.frame.size.width, textView.frame.size.height)].height);
    if (height >= maxHeight) {
        textView.scrollEnabled = YES;
        [textView setContentOffset:CGPointMake(textView.contentOffset.x, height - maxHeight) animated:YES];
        height = maxHeight;
    } else {
        textView.scrollEnabled = NO;
    }
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y + textView.frame.size.height - height, textView.frame.size.width, height);
    [textView layoutIfNeeded];
    
    
}


@end
