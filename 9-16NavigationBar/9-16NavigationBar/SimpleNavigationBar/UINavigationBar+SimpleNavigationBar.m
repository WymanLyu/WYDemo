//
//  UINavigationBar+SimpleNavigationBar.m
//  9-16NavigationBar
//
//  Created by wyman on 2017/9/16.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "UINavigationBar+SimpleNavigationBar.h"
#import "UINavigationBar+SimpleNavigationBarPrivateProperty.h"
#import "WYEasyObjEx.h"

@implementation UINavigationBar (SimpleNavigationBar)

#pragma mark - 拓展属性

OBJ_EX_IMP

STRONG(UIColor *, sn_backgroundColor)
ASSIGN(CGFloat, sn_alpha)
STRONG(UIView *, sn_customBarView)
COPY(NSString *, sn_ss)

OBJ_EX_END


@end



/** 原理 [拷贝到 @implementation @end]中调试
 
 #ifndef EXTEND_IMP_LIST_KEY_MACRO
 #define EXTEND_IMP_LIST_KEY_MACRO
 // 主入口
 + (void)EXTEND_OBJ_PROPERTY_triggle {
 static dispatch_once_t onceToken;
 dispatch_once(&onceToken, ^{
 // 1.初始化拓展方法列表
 if (nil==[self EXTEND_IMP_LIST]) {
 objc_setAssociatedObject(self, EXTEND_IMP_LIST_KEY, [NSMutableArray array], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
 }
 // 2.交换forwardingTargetForSelector方法
 SEL originSel = NSSelectorFromString(@"forwardingTargetForSelector:");
 SEL newSel = NSSelectorFromString(@"wy_forwardingTargetForSelector:");
 Method originMethod = class_getInstanceMethod(self, originSel);
 Method newMethod = class_getInstanceMethod(self, newSel);
 //首先动态添加方法，实现是新的方法，返回值表示添加成功还是失败[如果已经实现了则不会添加成功]
 BOOL isAdd = class_addMethod([self class], originSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
 if (isAdd) {
 // 如果成功，说明类中不存在这个方法的实现
 // 将被交换方法的实现替换到这个并不存在的实现
 class_replaceMethod([self class], newSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
 } else{
 //否则，交换两个方法的实现
 method_exchangeImplementations(originMethod, newMethod);
 }
 // 3.加载新增属性setter方法字符串
 [self performSelectorWithEqualPrefix:@"EXTEND_IMP_LIST_"];
 });
 }
 // 转发者和方法列表【此方法列表是"类型 + setxxx:"的字符串】
 static void *EXTEND_IMP_LIST_KEY = &EXTEND_IMP_LIST_KEY;
 static void *EXTEND_FORWARDING_TARGET_KEY = &EXTEND_FORWARDING_TARGET_KEY;
 + (NSMutableArray *)EXTEND_IMP_LIST {
 return objc_getAssociatedObject(self, EXTEND_IMP_LIST_KEY);
 }
 - (WYEasyObjExForwarding *)EXTEND_FORWARDING_TARGET {
 WYEasyObjExForwarding *forwarding =  objc_getAssociatedObject(self, EXTEND_FORWARDING_TARGET_KEY);
 if (!forwarding) {
 forwarding = [[WYEasyObjExForwarding alloc] init];
 forwarding.host = self;
 }
 return forwarding;
 }
 // 转发消息
 - (id)wy_forwardingTargetForSelector:(SEL)aSelector {
 // 1.新增的setter方法列表
 NSArray *exSetterFuncList = [[self class] performSelector:@selector(EXTEND_IMP_LIST)];
 for (NSString *exName in exSetterFuncList) {
 if (exName.length<4) break;
 // 3.获取方法名，参数类型
 NSString *selName = [exName substringWithRange:NSMakeRange(1,exName.length-1)];
 // 4.判断是否相等 eg：setAgc == setagc 【仅当此情况时转发】
 if ([NSStringFromSelector(aSelector) easyObjEx_setter_equalTo:selName] &&
 ![NSStringFromSelector(aSelector) isEqualToString:selName]) {
 return [self EXTEND_FORWARDING_TARGET];
 }
 }
 // 5.上面未符合条件则调原生
 return [self wy_forwardingTargetForSelector:aSelector];
 }
 // 调用 EXTEND_IMP_LIST_xxx方法
 + (void)performSelectorWithEqualPrefix:(NSString *)prefix {
 unsigned int methodCount = 0;
 const char *clsName = class_getName(self);
 Class metaClass = objc_getMetaClass(clsName);
 Method *methodList = class_copyMethodList(metaClass, &methodCount);
 for (int i = 0; i < methodCount ; i ++) {
 Method method = methodList[i];
 SEL selector = method_getName(method);
 const char *methodName = sel_getName(selector);
 NSString *methodNameOC = [NSString stringWithUTF8String:methodName];
 if (methodNameOC.length > prefix.length) {
 NSString *methodNameOCPrefix = [methodNameOC substringWithRange:NSMakeRange(0, prefix.length)];
 if ([methodNameOCPrefix isEqualToString:prefix]) {
 // 命中方法...调用
 NSLog(@"调用方法进容器..%@", methodNameOC);
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
 [[self class] performSelector:NSSelectorFromString(methodNameOC)];
 #pragma clang diagnostic pop
 }
 }
 }
 }
 // 调用EXTEND_IMP_ADD_xxx:types: 方法
 - (void)performSelectorWithinvocation:(NSInvocation *)invocation {
 // 1.获取拓展setter方法列表
 SEL aSelector = invocation.selector;
 // 2.遍历查询
 NSArray *exSetterFuncList = [[self class] performSelector:@selector(EXTEND_IMP_LIST)];
 for (NSString *exName in exSetterFuncList) {
 NSLog(@"---%@", exName);
 if (exName.length<4) break;
 // 3.获取方法名，参数类型
 NSString *type = [exName substringWithRange:NSMakeRange(0, 1)];
 NSString *selName = [exName substringWithRange:NSMakeRange(1,exName.length-1)];
 NSString *typeString = [NSString stringWithFormat:@"v@:%@", type];
 // 4.判断是否相等 eg：setAgc == setagc 【仅当此情况时转发】
 if ([NSStringFromSelector(aSelector) easyObjEx_setter_equalTo:selName] &&
 ![NSStringFromSelector(aSelector) isEqualToString:selName]) {
 // 5.触发host增加方法【第一次来这时没有该方法，动态加载后不再进来此处转发】
 NSString *addMethodString = [@"EXTEND_IMP_ADD_" stringByAppendingString:[selName substringWithRange:NSMakeRange(0, selName.length-1)]];
 NSLog(@"调用增加方法..%@", addMethodString);
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
 __aSelectorString = NSStringFromSelector(aSelector);
 __tString = typeString;
 [self performSelector:NSSelectorFromString(addMethodString)];
 [invocation invokeWithTarget:self];
 #pragma clang diagnostic pop
 break;
 }
 }
 }
 
 + (void)performSelectorWithEqualPrefix:(NSString *)prefix types:(NSString *)typeString {
 unsigned int methodCount = 0;
 const char *clsName = class_getName(self);
 Class metaClass = objc_getMetaClass(clsName);
 Method *methodList = class_copyMethodList(metaClass, &methodCount);
 for (int i = 0; i < methodCount ; i ++) {
 Method method = methodList[i];
 SEL selector = method_getName(method);
 const char *methodName = sel_getName(selector);
 NSString *methodNameOC = [NSString stringWithUTF8String:methodName];
 if (methodNameOC.length > prefix.length) {
 NSString *methodNameOCPrefix = [methodNameOC substringWithRange:NSMakeRange(0, prefix.length-1)];
 if ([methodNameOCPrefix isEqualToString:prefix]) {
 // 命中方法...调用
 NSLog(@"命中方法..%@", methodNameOC);
 #pragma clang diagnostic push
 #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
 //                [[self class] performSelector:NSSelectorFromString(methodNameOC) withObject:typeString];
 __aSelectorString = prefix;
 __tString = typeString;
 [[self class] performSelector:NSSelectorFromString(methodNameOC)];
 #pragma clang diagnostic pop
 }
 }
 }
 }
 static NSString *__aSelectorString = nil;
 static NSString *__tString = nil;
 #endif
 
 // 1.增加【类型/方法名】到新增setter方法列表中
 + (void)EXTEND_IMP_LIST_1 {
 [[self EXTEND_IMP_LIST] addObject:@"dsetsn_alpha:"];
 }
 // 2.增加真实的setter方法【之前在1.中是setagc: 此时绑定实现到setAgc: 此处传值用静态变量由于宏不支持:符号导致....】
 - (void)EXTEND_IMP_ADD_setsn_alpha  {
 // 增加方法
 class_addMethod([self class], NSSelectorFromString(__aSelectorString), (IMP)setsn_alpha,[__tString cStringUsingEncoding:NSUTF8StringEncoding]);
 }
 static const void *sn_alphaKey = &sn_alphaKey;
 void setsn_alpha(id self, SEL _cmd, CGFloat OBJ) {
 NSLog(@"设置%f", OBJ);
 objc_setAssociatedObject(self, sn_alphaKey, @(OBJ), OBJC_ASSOCIATION_COPY_NONATOMIC);
 }
 
 - (CGFloat)sn_alpha {
 NSNumber *obj = objc_getAssociatedObject(self, sn_alphaKey);
 NSLog(@"读取%@", obj);
 return (CGFloat)[obj doubleValue];
 }
 
 
 // 1.增加【类型/方法名】到新增setter方法列表中
 + (void)EXTEND_IMP_LIST_2 {
 [[self EXTEND_IMP_LIST] addObject:@"@setsn_backgroundColor:"];
 }
 // 2.增加真实的setter方法【之前在1.中是setagc: 此时绑定实现到setAgc:】
 - (void)EXTEND_IMP_ADD_setsn_backgroundColor:(NSString *)aSelectorString types:(NSString *)typeString  {
 // 增加方法
 class_addMethod([self class], NSSelectorFromString(aSelectorString), (IMP)setsn_backgroundColor,[typeString cStringUsingEncoding:NSUTF8StringEncoding]);
 }
 static const void *sn_backgroundColorKey = &sn_backgroundColorKey;
 void setsn_backgroundColor(id self, SEL _cmd, UIColor *OBJ) {
 NSLog(@"设置%@", OBJ);
 objc_setAssociatedObject(self, sn_backgroundColorKey, OBJ, OBJC_ASSOCIATION_COPY_NONATOMIC);
 }
 
 - (UIColor *)sn_backgroundColor {
 UIColor *obj = objc_getAssociatedObject(self, sn_backgroundColorKey);
 NSLog(@"读取%@", obj);
 return obj;
 
 }
 
 */
