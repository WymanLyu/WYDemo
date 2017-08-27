//
//  NSObject+WYRuntime.m
//  12-12WYEvent
//
//  Created by wyman on 2017/8/25.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import "NSObject+WYRuntime.h"
#import <objc/runtime.h>

@implementation NSObject (WYRuntime)

///通过运行时获取当前对象的所有属性的名称，以数组的形式返回
+ (NSArray *)wy_allPropertyNames {
    ///存储所有的属性名称
   NSMutableArray *allNames = [[NSMutableArray alloc] init];
    ///存储属性的个数
     unsigned int propertyCount = 0;
   ///通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
      ///取出第一个属性
        objc_property_t property = propertys[i];
         const char * propertyName = property_getName(property);
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }

     ///释放
    free(propertys);
   return allNames;
}

#pragma mark -- 通过字符串来创建该字符串的Setter方法，并返回
+ (SEL)wy_creatSetterWithPropertyName:(NSString *)propertyName {
    NSString *selString = [NSString stringWithFormat:@"set%@:",[propertyName capitalizedString]];
    return NSSelectorFromString(selString);
}

+ (SEL)wy_creatGetterWithPropertyName:(NSString *)propertyName {
    return NSSelectorFromString(propertyName);
}

- (void)wy_bind:(id)obj value:(NSString *)key {
    NSString *propertyName = nil;
    for (NSString *name in [[self class] wy_allPropertyNames]) {
        SEL getter = [[self class] wy_creatGetterWithPropertyName:name];
        id property = [self performSelector:getter];
        if (obj == property) {
            propertyName = name;
            break;
        }
    }
    if (!propertyName) {
        return;
    }
    SEL setter = [[self class] wy_creatSetterWithPropertyName:propertyName];
    __weak typeof(self)weakSelf = self;
    [self wy_observePath:key target:obj options:NSKeyValueObservingOptionNew change:^(NSDictionary<NSKeyValueChangeKey,id> *change) {
        [weakSelf performSelector:setter withObject:obj];
    }];
}

@end
