//
//  Transition.h
//  12-16VcTransition
//
//  Created by wyman on 2016/12/16.
//  Copyright © 2016年 tykj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TransitionType) {
    TransitionTypePresent,
    TransitionTypeDismiss,

};

@interface Transition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, copy) CGRect(^rectInWindow)(void);

@property (nonatomic, assign) TransitionType type;

@end
