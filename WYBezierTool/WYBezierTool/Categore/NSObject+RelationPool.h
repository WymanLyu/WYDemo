//
//  NSObject+RelationPool.h
//  WYBezierTool
//
//  Created by yunyao on 2016/9/26.
//  Copyright © 2016年 yunyao. All rights reserved.
//  这个不是线程安全的数据结构

#import <Foundation/Foundation.h>

@interface NSObject (RelationPool)

/** 对象关系池 */
@property (nonatomic, strong, readonly, nullable) NSMutableSet *wy_pool;

/** 获取池子的所用伙伴对象 */
- (nullable NSMutableSet *)wy_getPoolParners;

/** 向池子中添加伙伴（或则添加进伙伴的池子） */
- (void)wy_addPoolParner:(nullable NSObject *)parnerObj;

/** 退出池子 */
- (void)wy_withdrawPool;

/** 解散池子 */
- (void)wy_dismissPool;

@end
