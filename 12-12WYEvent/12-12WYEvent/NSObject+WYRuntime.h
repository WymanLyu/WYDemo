//
//  NSObject+WYRuntime.h
//  12-12WYEvent
//
//  Created by wyman on 2017/8/25.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import <Foundation/Foundation.h>


//#define metamacro_concat_(A, B) A ## B
//
//#define metamacro_concat(A, B) \
//        metamacro_concat_(A, B)
//
//#define metamacro_at(N, ...) \
//    metamacro_concat(metamacro_at, N)(__VA_ARGS__)
//
//#define metamacro_argcount(...) \
//    metamacro_at(20, __VA_ARGS__, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
//
//#define keypath1(PATH) \
//(((void)(NO && ((void)PATH, NO)), strchr(# PATH, '.') + 1))
//
//#define keypath2(OBJ, PATH) \
//(((void)(NO && ((void)OBJ.PATH, NO)), # PATH))
//
//#define metamacro_if_eq(A, B) \
//metamacro_concat(metamacro_if_eq, A)(B)
//
//#define keypath(...) \
//    metamacro_if_eq(1, metamacro_argcount(__VA_ARGS__))(keypath1(__VA_ARGS__))(keypath2(__VA_ARGS__))


#define keyPath(objc,keyPath) @(((void)objc.keyPath,#keyPath))



@interface NSObject (WYRuntime)

+ (NSArray *)wy_allPropertyNames;
+ (SEL)wy_creatSetterWithPropertyName:(NSString *)propertyName;
+ (SEL)wy_creatGetterWithPropertyName:(NSString *)propertyName;


- (void)wy_bind:(id)obj value:(NSString *)key;

@end
