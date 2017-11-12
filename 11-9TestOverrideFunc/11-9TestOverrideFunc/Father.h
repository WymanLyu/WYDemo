//
//  Father.h
//  11-9TestOverrideFunc
//
//  Created by wyman on 2017/11/9.
//  Copyright © 2017年 wyman. All rights reserved.
//

#ifndef NS_REQUIRES_SUPER
#if __has_attribute(objc_requires_super)
#define NS_REQUIRES_SUPER __attribute__((objc_requires_super))
#else
#define NS_REQUIRES_SUPER
#endif
#endif


#import <Foundation/Foundation.h>

@interface Father : NSObject

/** 子类必须重写 */
- (void)eat NS_REQUIRES_SUPER;


@end
