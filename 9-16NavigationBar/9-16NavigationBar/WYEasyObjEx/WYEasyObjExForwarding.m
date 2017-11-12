//
//  WYEasyObjExForwarding.m
//  9-16NavigationBar
//
//  Created by wyman on 2017/9/17.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "WYEasyObjExForwarding.h"
#import "NSString+WYEasyObjEx.h"
#import <objc/runtime.h>
#import <pthread.h>


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"

@implementation WYEasyObjExForwarding

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([self.host respondsToSelector:@selector(performSelectorWithinvocation:)]) {
        [self.host performSelector:@selector(performSelectorWithinvocation:) withObject:invocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

@end


// runtime之后，在main之前。启动消息转发
static pthread_mutex_t protocolsLoadingLock = PTHREAD_MUTEX_INITIALIZER;
__attribute__((constructor)) static void _easyObjcEx_beforeMain(void) {
    
    pthread_mutex_lock(&protocolsLoadingLock);
    
    unsigned classCount = 0;
    Class *allClasses = objc_copyClassList(&classCount);
    @autoreleasepool {
        // 遍历所有类，启动消息转发
        for (unsigned index = 1; index < classCount; ++index) {
            Class class = allClasses[index];
            unsigned classMethodCount = 0;
            Class metaClass = objc_getMetaClass(class_getName(class));
            Method *classMethodList = class_copyMethodList(metaClass, &classMethodCount);
            for (unsigned m_index = 1; m_index < classMethodCount; ++m_index) {
                Method m = classMethodList[m_index];
                NSString *selName = NSStringFromSelector(method_getName(m));
                if ([selName isEqualToString:@"EXTEND_OBJ_PROPERTY_triggle"]) {
//                    NSLog(@"class:%@---%@",[NSString stringWithUTF8String:class_getName(class)], selName);
                    [class performSelector:NSSelectorFromString(@"EXTEND_OBJ_PROPERTY_triggle")];
                }
            }
            if (NULL!=classMethodList) {
                free(classMethodList);
            }

        }
    }
    pthread_mutex_unlock(&protocolsLoadingLock);
    // 释放内存
    free(allClasses);
}

#pragma clang diagnostic pop
