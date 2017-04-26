//
//  WYTextView.h
//  4-25输入框实现
//
//  Created by wyman on 2017/4/25.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYInputAccessoryToolView.h"

@interface WYTextView : UITextView

/** 最大行数 */
@property (nonatomic, assign) NSInteger maxLineNumber;

/** 视图高度 */
@property CGFloat previousTextViewHeight;

/** 自动调整控制器视图(所以此视图加入vc的view时，在followContentChange调整此时图尺寸有冲突，要关闭此属性) */
@property (nonatomic, assign) bool autoFixVcViewHeight;

/** 跟随键盘的回调 */
@property (nonatomic, copy) void(^followKeyBoardChange)(CGFloat keyBoardY, CGFloat animateDuration);

/** 跟随文本内容的回调 */
@property (nonatomic, copy) void(^followContentChange)(CGFloat changeInHeight, CGFloat animateDuration);


@end

