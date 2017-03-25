//
//  NSObject+WYKVO.h
//  12-12WYEvent
//
//  Created by wyman on 2017/3/25.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYKVOObserver.h"
#import "WYKVOTarget.h"

@interface NSObject (WYKVO)

@property (nonatomic, strong) WYKVOObserver *wy_kvoObserver;

@property (nonatomic, strong) WYKVOTarget *wy_kvoTarget;

@end
