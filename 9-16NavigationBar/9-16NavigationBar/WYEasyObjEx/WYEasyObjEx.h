//
//  WYEasyObjEx.h
//  9-16NavigationBar
//
//  Created by wyman on 2017/9/16.
//  Copyright © 2017年 wyman. All rights reserved.
//

#ifndef WYEasyObjEx_h
#define WYEasyObjEx_h

#import <objc/runtime.h>
#import "NSString+WYEasyObjEx.h"
#import "WYEasyObjExForwarding.h"

#define EASY_OBJEX_AFTER_CLASS_LOAD_CALL \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\" ")\
\
+ (void)EXTEND_OBJ_PROPERTY_triggle { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        if (nil==[self EXTEND_IMP_LIST]) { \
            objc_setAssociatedObject(self, EXTEND_IMP_LIST_KEY, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
        } \
        SEL originSel = NSSelectorFromString(@"forwardingTargetForSelector:"); \
        SEL newSel = NSSelectorFromString(@"wy_forwardingTargetForSelector:"); \
        Method originMethod = class_getInstanceMethod(self, originSel); \
        Method newMethod = class_getInstanceMethod(self, newSel); \
        BOOL isAdd = class_addMethod([self class], originSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)); \
        if (isAdd) { \
            class_replaceMethod([self class], newSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod)); \
        } else{ \
            method_exchangeImplementations(originMethod, newMethod); \
        } \
        [self performSelectorWithEqualPrefix:@"EXTEND_IMP_LIST_"]; \
    }); \
} \
 \
static void *EXTEND_IMP_LIST_KEY = &EXTEND_IMP_LIST_KEY; \
static void *EXTEND_FORWARDING_TARGET_KEY = &EXTEND_FORWARDING_TARGET_KEY; \
+ (NSMutableArray *)EXTEND_IMP_LIST { \
    return objc_getAssociatedObject(self, EXTEND_IMP_LIST_KEY); \
} \
- (WYEasyObjExForwarding *)EXTEND_FORWARDING_TARGET { \
    WYEasyObjExForwarding *forwarding =  objc_getAssociatedObject(self, EXTEND_FORWARDING_TARGET_KEY); \
    if (!forwarding) { \
        forwarding = [[WYEasyObjExForwarding alloc] init]; \
        forwarding.host = self; \
    } \
    return forwarding; \
} \
 \
- (id)wy_forwardingTargetForSelector:(SEL)aSelector { \
    NSArray *exSetterFuncList = [[self class] performSelector:@selector(EXTEND_IMP_LIST)]; \
    for (NSString *exName in exSetterFuncList) { \
        if (exName.length<4) break; \
        NSString *selName = [exName substringWithRange:NSMakeRange(1,exName.length-1)]; \
        if ([NSStringFromSelector(aSelector) easyObjEx_setter_equalTo:selName] && \
            ![NSStringFromSelector(aSelector) isEqualToString:selName]) { \
            return [self EXTEND_FORWARDING_TARGET]; \
        } \
    } \
    return [self wy_forwardingTargetForSelector:aSelector]; \
} \
 \
+ (void)performSelectorWithEqualPrefix:(NSString *)prefix { \
    unsigned int methodCount = 0; \
    const char *clsName = class_getName(self); \
    Class metaClass = objc_getMetaClass(clsName); \
    Method *methodList = class_copyMethodList(metaClass, &methodCount); \
    for (int i = 0; i < methodCount ; i ++) { \
        Method method = methodList[i]; \
        SEL selector = method_getName(method); \
        const char *methodName = sel_getName(selector); \
        NSString *methodNameOC = [NSString stringWithUTF8String:methodName]; \
        if (methodNameOC.length > prefix.length) { \
            NSString *methodNameOCPrefix = [methodNameOC substringWithRange:NSMakeRange(0, prefix.length)]; \
            if ([methodNameOCPrefix isEqualToString:prefix]) { \
                [[self class] performSelector:NSSelectorFromString(methodNameOC)]; \
            } \
        } \
    } \
} \
- (void)performSelectorWithinvocation:(NSInvocation *)invocation { \
    SEL aSelector = invocation.selector; \
    NSArray *exSetterFuncList = [[self class] performSelector:@selector(EXTEND_IMP_LIST)]; \
    for (NSString *exName in exSetterFuncList) { \
        if (exName.length<4) break; \
        NSString *type = [exName substringWithRange:NSMakeRange(0, 1)]; \
        NSString *selName = [exName substringWithRange:NSMakeRange(1,exName.length-1)]; \
        NSString *typeString = [NSString stringWithFormat:@"v@:%@", type]; \
        if ([NSStringFromSelector(aSelector) easyObjEx_setter_equalTo:selName] && \
            ![NSStringFromSelector(aSelector) isEqualToString:selName]) { \
            NSString *addMethodString = [@"EXTEND_IMP_ADD_" stringByAppendingString:[selName substringWithRange:NSMakeRange(0, selName.length-1)]]; \
            __aSelectorString = NSStringFromSelector(aSelector); \
            __tString = typeString; \
            [self performSelector:NSSelectorFromString(addMethodString)]; \
            [invocation invokeWithTarget:self]; \
            break; \
        } \
    } \
} \
static NSString *__aSelectorString = nil; \
static NSString *__tString = nil; \
_Pragma("clang diagnostic pop")  \

////////////////////////////////////////////////

#define OBJ_EX_IMP EASY_OBJEX_AFTER_CLASS_LOAD_CALL


#define OBJ_EX_END

////////////////////////////////////////////////

#define APPEND(A, B) A##_##B
#define APPEND_COUNT(M, COUNT) APPEND(M, COUNT)
#define STATIC_KEY(VALUE) VALUE##ValueKey

#define STRINGIFY(S) #S
#define STRINGIFY_PACKAGE(S) STRINGIFY(S)

// 傻逼宏不能再后面拼接: 前面不能有@ 真jb蛋疼 导致转发消息传值用静态变量
// 1.产生方法名
#define APPEND_NAME(OBJ) set##OBJ
// 2.产生带type的SEL
#define APPEND_TYPE(OBJ) d##set##OBJ
// 3.@"TypeXXX:"
#define OC_SETTER_SEL_TYPE(OBJ) [[NSString stringWithUTF8String:STRINGIFY_PACKAGE(APPEND_TYPE(OBJ))] stringByAppendingString:[NSString stringWithUTF8String:STRINGIFY(:)]];
// 5.产生add方法名
#define APPEND_ADD_NAME(OBJ) EXTEND_IMP_ADD_##set##OBJ

////////////////////////////////////////////////

// strong类型对象
#define STRONG(TYPE,OBJ) \
+ (void)APPEND_COUNT(EXTEND_IMP_LIST, __COUNTER__) { \
    NSString *selString = OC_SETTER_SEL_TYPE(OBJ) \
    [[self EXTEND_IMP_LIST] addObject:selString]; \
} \
- (void)APPEND_ADD_NAME(OBJ){ \
    class_addMethod([self class], NSSelectorFromString(__aSelectorString), (IMP)APPEND_NAME(OBJ),[__tString cStringUsingEncoding:NSUTF8StringEncoding]); \
} \
static const void *STATIC_KEY(OBJ) = &STATIC_KEY(OBJ); \
void APPEND_NAME(OBJ)(id self, SEL _cmd, TYPE OBJ) { \
    objc_setAssociatedObject(self, STATIC_KEY(OBJ), OBJ, OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
} \
- (TYPE)OBJ { \
    TYPE obj = objc_getAssociatedObject(self, STATIC_KEY(OBJ)); \
    return obj; \
}

// assign类型
#define ASSIGN(TYPE,OBJ) \
+ (void)APPEND_COUNT(EXTEND_IMP_LIST, __COUNTER__) { \
    NSString *selString = OC_SETTER_SEL_TYPE(OBJ) \
    [[self EXTEND_IMP_LIST] addObject:selString]; \
} \
- (void)APPEND_ADD_NAME(OBJ){ \
    class_addMethod([self class], NSSelectorFromString(__aSelectorString), (IMP)APPEND_NAME(OBJ),[__tString cStringUsingEncoding:NSUTF8StringEncoding]); \
} \
static const void *STATIC_KEY(OBJ) = &STATIC_KEY(OBJ); \
void APPEND_NAME(OBJ)(id self, SEL _cmd, TYPE OBJ) { \
    objc_setAssociatedObject(self, STATIC_KEY(OBJ), [NSNumber numberWithDouble:OBJ], OBJC_ASSOCIATION_COPY_NONATOMIC); \
} \
- (TYPE)OBJ { \
    NSNumber *obj = objc_getAssociatedObject(self, STATIC_KEY(OBJ)); \
    return (TYPE)[obj doubleValue]; \
}

// copy类型
#define COPY(TYPE,OBJ) \
+ (void)APPEND_COUNT(EXTEND_IMP_LIST, __COUNTER__) { \
    NSString *selString = OC_SETTER_SEL_TYPE(OBJ) \
    [[self EXTEND_IMP_LIST] addObject:selString]; \
} \
- (void)APPEND_ADD_NAME(OBJ){ \
    class_addMethod([self class], NSSelectorFromString(__aSelectorString), (IMP)APPEND_NAME(OBJ),[__tString cStringUsingEncoding:NSUTF8StringEncoding]); \
} \
static const void *STATIC_KEY(OBJ) = &STATIC_KEY(OBJ); \
void APPEND_NAME(OBJ)(id self, SEL _cmd, TYPE OBJ) { \
    objc_setAssociatedObject(self, STATIC_KEY(OBJ), OBJ, OBJC_ASSOCIATION_COPY_NONATOMIC); \
} \
- (TYPE)OBJ { \
    TYPE obj = objc_getAssociatedObject(self, STATIC_KEY(OBJ)); \
    return obj; \
}



















#endif /* WYEasyObjEx_h */
