//
//  CTFrameParserConfig.h
//  WYCoreTextDemo
//
//  Created by sialice on 16/5/16.
//  Copyright © 2016年 wyman. All rights reserved.
//  文本配置

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>


/* JSON文本配置格式
 [ {
    "type" : "img",
    "width" : 200,
    "height" : 108,
    "name" : "coretext-image-1.jpg"
  },
  { 
    "color" : "blue",
    "content" : " 更进一步地，实际工作中，我们更希望通过一个排版文件，来设置需要排版的文字的 ",
    "size" : 16,
    "type" : "txt"
  },
  { 
    "color" : "red",
    "content" : " 内容、颜色、字体 ",
    "size" : 22,
    "type" : "txt"
  },
  { 
    "color" : "black",
    "content" : " 大小等信息。\n",
    "size" : 16,
    "type" : "txt"
  },
  {
    "type" : "img",
    "width" : 200,
    "height" : 130,
    "name" : "coretext-image-2.jpg"
  },
  { "color" : "default",
    "content" : " 我在开发猿题库应用时，自己定义了一个基于 UBB 的排版模版，但是实现该排版文件的解析器要花费大量的篇幅，考虑到这并不是本章的重点，所以我们以一个较简单的排版文件来讲解其思想。",
    "type" : "txt"
  }
]
 */

@interface CTFrameParserConfig : NSObject

/** 文本宽度 */
@property (nonatomic, assign) CGFloat width;

/** 字号 */
@property (nonatomic, assign) CGFloat fontSize;

/** 线宽 */
@property (nonatomic, assign) CGFloat lineSpace;

/** 文本颜色 */
@property (nonatomic, strong) UIColor *textColor;

@end
