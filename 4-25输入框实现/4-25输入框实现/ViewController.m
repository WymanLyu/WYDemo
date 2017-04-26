//
//  ViewController.m
//  4-25输入框实现
//
//  Created by wyman on 2017/4/25.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "WYTextView.h"

@interface ViewController()

@property CGFloat previousTextViewHeight;

@end

@interface ViewController ()

@property (nonatomic, strong) WYTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
    v.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:v];
    
    WYTextView *textView = [[WYTextView alloc] init];
    textView.backgroundColor = [UIColor grayColor];
    textView.frame = CGRectMake(self.view.frame.size.width*0.2*0.5, 4, self.view.frame.size.width*0.8, 36);
    textView.autoFixVcViewHeight = NO;
    [v addSubview:textView];
    __weak typeof(v)weakV = v;
    __weak typeof(textView)weakTextView = textView;
    textView.followKeyBoardChange = ^(CGFloat keyBoardY, CGFloat animateDuration){
        CGRect vF = weakV.frame;
        vF.origin.y = keyBoardY - vF.size.height;
        [UIView animateWithDuration:animateDuration animations:^{
            weakV.frame = vF;
        }];
    };
    textView.followContentChange = ^(CGFloat changeInHeight, CGFloat animateDuration){
        CGRect vF = weakV.frame;
        [UIView animateWithDuration:animateDuration animations:^{
             v.frame = CGRectMake(vF.origin.x, vF.origin.y - changeInHeight, vF.size.width, vF.size.height + changeInHeight);
            weakTextView.frame = CGRectMake(self.view.frame.size.width*0.2*0.5, 4, self.view.frame.size.width*0.8, weakTextView.frame.size.height + changeInHeight);
        }];
    };
    
    self.textView = textView;
    
    
   
}



@end
