//
//  WYHorizonScaleCell.m
//  WYHorizonScaleCollectionView
//
//  Created by wyman on 2017/2/8.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYHorizonScaleCell.h"

@implementation WYHorizonScaleCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *imgView = [UIView new];
        imgView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:imgView];
        _imgView = imgView;
        
        UIView *discView = [UIView new];
        discView.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:discView];
        _discView = discView;
        
        [self observeValueForKeyPath:@"bounds" ofObject:self change:nil context:nil];

    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"bounds"]) {
        NSValue *frameValue = [change objectForKey:NSKeyValueChangeNewKey];
        CGRect newFrame = [frameValue CGRectValue];
        
        CGFloat scale = (185 - newFrame.size.width) / (185.0 - 147);
         NSLog(@"==%f", newFrame.size.height);
        if (scale>1 || scale <= 0) {
            scale = 1;
        }
       
        
        self.imgView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
        self.discView.frame = CGRectMake( self.frame.size.height, 0,  (self.frame.size.width - self.frame.size.height)*scale, self.frame.size.height);
        
    }
    
    
}

//- (void)setTransform:(CGAffineTransform)transform {
//    [super setTransform:transform];
//    NSLog(@"%s-", __func__);
//}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    NSLog(@"%s-%f", __func__, pow(layoutAttributes.alpha, 8));
    CGFloat scale = pow(layoutAttributes.alpha, 10);
    if (scale < 0.1) {
        scale = 0;
    }
    self.imgView.frame = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height);
    self.discView.frame = CGRectMake( self.bounds.size.height, 0,  (self.bounds.size.width - self.bounds.size.height)*(scale), self.bounds.size.height);
    
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
//    NSLog(@"%s", __func__);
    CGFloat scale = (185 - bounds.size.width) / (185.0 - 147);
//    NSLog(@"==%f", bounds.size.width);
    if (scale>1 || scale <= 0) {
        scale = 1;
    }
    
    
    self.imgView.frame = CGRectMake(0, 0, bounds.size.height, bounds.size.height);
    self.discView.frame = CGRectMake( bounds.size.height, 0,  (bounds.size.width - bounds.size.height)*scale, bounds.size.height);

}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    NSLog(@"%s", __func__);
//    
//    NSLog(@"%f", self.frame.size.height );// / (185 - 147)
//    
//    self.imgView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
//    self.discView.frame = CGRectMake( self.frame.size.height, 0,  self.frame.size.width - self.frame.size.height, self.frame.size.height);
//    
//}

@end
