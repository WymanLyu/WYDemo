//
//  TransitionViewController.h
//  12-16VcTransition
//
//  Created by wyman on 2016/12/16.
//  Copyright © 2016年 tykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransitionViewController : UIViewController

@property (nonatomic, copy) CGRect(^rectInWindow)(void);

@end
