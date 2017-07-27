//
//  FXBaseView.h
//  FXAudioSDKDemo
//
//  Created by wyman on 2017/7/27.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FXAudio/FXHeader.h>

@interface FXBaseView : UIView

@property (weak, nonatomic) IBOutlet UILabel *FXName;

+ (id)viewFromNibNamed:(NSString*)nibName owner:(id)owner;

- (void)enble:(UISwitch *)enbleSwitch;// 子类重写

@end
