//
//  NSObject+RelationPool.m
//  WYBezierTool
//
//  Created by yunyao on 2016/9/26.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "NSObject+RelationPool.h"
#import <objc/runtime.h>

const void *WYPoolAssociatedObjectKey = &WYPoolAssociatedObjectKey;

@implementation NSObject (RelationPool)

- (NSMutableSet *)wy_pool {
     return objc_getAssociatedObject(self, WYPoolAssociatedObjectKey);
}

- (void)setWy_pool:(NSMutableSet *)wy_pool {
    objc_setAssociatedObject(self, WYPoolAssociatedObjectKey, wy_pool, OBJC_ASSOCIATION_RETAIN);
}

/** 获取池子的所用伙伴对象 */
- (nullable NSMutableSet *)wy_getPoolParners {
    
    if (!self.wy_pool) return nil;
    
    // 1.获取池子
    NSMutableSet *setM = self.wy_pool;
    
    // 2.赋值池子
    NSMutableArray *setCopyArr = [NSMutableArray array];
    for (NSObject *obj in [setM allObjects]) {
        if (obj == self) {
            continue;
        }
        [setCopyArr addObject:obj];
    }
    NSMutableSet *setCopy = [NSMutableSet setWithArray:setCopyArr];
    
    // 3.创建只有自己的小池子
    NSSet *mySet = [NSSet setWithObject:self];
    
    // 4.移除自己
    [setCopy minusSet:mySet];
    
    return setCopy;
}

/** 向池子中添加伙伴（或则添加进伙伴的池子） */
- (void)wy_addPoolParner:(nullable NSObject *)parnerObj {
    
    if (!parnerObj) return;
    
    if (self.wy_pool) { // 1.自己有池子
        
        if (!parnerObj.wy_pool) { // 1.1.被邀请者没有在其他的池子中

            [self.wy_pool addObject:parnerObj];

            // 共享池子
            parnerObj.wy_pool = self.wy_pool;

        } else { // 1.2.被邀请者在其他的池子中 合并两个池子
            
            if (parnerObj.wy_pool == self.wy_pool) return; // 相同池子不处理
            
            NSArray *parnerPoolObjs = [parnerObj.wy_pool allObjects];
            // 解除池子
            [parnerObj wy_dismissPool];
            // 加入池子
            [parnerPoolObjs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self wy_addPoolParner:obj];
            }];
            
        }
        
    } else { // 2.自己没有池子
        
        if (parnerObj.wy_pool) { // 2.1.被邀请者有池子则加入被邀请者的池子中
            [parnerObj.wy_pool addObject:self];
            // 共享池子
            self.wy_pool = parnerObj.wy_pool;
            
        } else { // 2.2.自己没有池子且被邀请者也没有池子 组成同一个池子
            self.wy_pool = [NSMutableSet set];
            if (self.wy_pool) {
                [self.wy_pool addObject:self];
                [self wy_addPoolParner:parnerObj];
            }
        }
    }    
}

/** 退出池子 */
- (void)wy_withdrawPool {
    
    if (self.wy_pool) {
        [self.wy_pool removeObject:self];
    }
    
}

/** 解散池子 */
- (void)wy_dismissPool {
    
    if (self.wy_pool) {
        NSMutableSet *set = [self wy_getPoolParners];

        [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSObject *object = (NSObject *)obj;
            [object wy_withdrawPool];
            object.wy_pool = nil;
        }];
        [self wy_withdrawPool];
        self.wy_pool = nil;
    }
    
}

@end
