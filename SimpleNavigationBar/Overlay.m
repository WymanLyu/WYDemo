//
//  Overlay.m
//  SimpleNavigationBar
//
//  Created by wyman on 2017/9/13.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "Overlay.h"

@implementation Overlay

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setFrame:(CGRect)frame {
    NSLog(@"%@-- %@ -- %@", NSStringFromCGRect(self.frame), NSStringFromCGRect(self.superview.frame), NSStringFromCGRect(self.superview.superview.frame));
    if (frame.origin.x!=0 || frame.origin.y!= 0) {
        return;
    }
    [super setFrame:frame];
}
- (void)setCenter:(CGPoint)center {
    NSLog(@"center:%@", NSStringFromCGPoint(center));
    [super setCenter:center];
}

- (void)setBounds:(CGRect)bounds {
    NSLog(@"bounds:%@", NSStringFromCGRect(bounds));
    [super setBounds:bounds];
}

- (CALayer *)layer {
    [self.layer removeAllAnimations];
    return self.layer;
}






@end
