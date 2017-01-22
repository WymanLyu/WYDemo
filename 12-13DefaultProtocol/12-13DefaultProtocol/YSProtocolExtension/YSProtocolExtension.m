//
//  YSProtocolExtension.m
//  YouSay
//
//  Created by wyman on 2016/12/12.
//  Copyright © 2016年 tykj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSProtocolExtension.h"
#import <pthread.h>
#include <stdio.h>

static pthread_mutex_t protocolsLoadingLock = PTHREAD_MUTEX_INITIALIZER;

/////////////////////////////// 数据结构

#define MAX_EXTENDED_PROTOCOLLIST_LENGTH 100

// 协议内容
typedef struct YSExtendedProtocol {
    // 协议
    Protocol *__unsafe_unretained protocol;
    // 对象方法
    Method *instanceMethods;
    // 对象方法数
    unsigned instanceMethodCount;
    // 类方法
    Method *classMethods;
    // 类方法数
    unsigned classMethodCount;
    // 析构函数
    void (*extendedProtocol_free)(struct YSExtendedProtocol *);
} YSExtendedProtocol;

// 析构函数
static void extendedProtocol_free(YSExtendedProtocol *extendedProtocol) {
    // 释放各种存储链表
    if (extendedProtocol->instanceMethods != NULL) {
        free(extendedProtocol->instanceMethods);
    }
    if (extendedProtocol->classMethods != NULL) {
        free(extendedProtocol->classMethods);
    }
    
    // 置空
    extendedProtocol->protocol = NULL;
    extendedProtocol->instanceMethods = NULL;
    extendedProtocol->classMethods = NULL;
    extendedProtocol->extendedProtocol_free = NULL;
}

// 缓存链表
typedef struct YSExtendedProtocolList {
    // 链表容器
    YSExtendedProtocol *extendedProtocolCaches;
    // 容器大小
    unsigned listLength;
    // 阈值
    unsigned maxLength;
    // 析构函数
    void (*extendedProtocolList_free)(struct YSExtendedProtocolList *);
} YSExtendedProtocolList;

// 析构函数
static void extendedProtocolList_free(YSExtendedProtocolList *extendedProtocolList) {
    // 释放链表指向的结构体申请的内存
    for (unsigned index = 0; index < extendedProtocolList->listLength; ++index) {
        YSExtendedProtocol *extendedProtocol = extendedProtocolList->extendedProtocolCaches + index;
        if (extendedProtocol != NULL) {
            extendedProtocol->extendedProtocol_free(extendedProtocol);
        }
    }
    // 释放链表
    if (extendedProtocolList->extendedProtocolCaches != NULL) {
        free(extendedProtocolList->extendedProtocolCaches);
    }
    // 置空
    extendedProtocolList->extendedProtocolCaches = NULL;
    extendedProtocolList->extendedProtocolList_free = NULL;
}

static YSExtendedProtocolList *extendedProtocolList = NULL;

/////////////////////////////// 私有函数

// 记录工程的默认协议
extern void _ys_load_protocol(Protocol *protocol, Class containerClass) {
    
    // 1.创建协议缓存链表(申请YSExtendedProtocolList堆内存)
    if (NULL == extendedProtocolList) {
        extendedProtocolList = malloc(sizeof(YSExtendedProtocolList));
        extendedProtocolList->listLength = 0;
        extendedProtocolList->maxLength = MAX_EXTENDED_PROTOCOLLIST_LENGTH;
        extendedProtocolList->extendedProtocolList_free = extendedProtocolList_free;
        extendedProtocolList->extendedProtocolCaches = NULL;
    }
    
    // 2.增加缓存协议
    // 2.1.校验有无剩余容量
    if (extendedProtocolList->listLength >= MAX_EXTENDED_PROTOCOLLIST_LENGTH) {
        return;
    }
    // 2.2.增加协议
    extendedProtocolList->listLength ++;
    // （申请YSExtendedProtocol的堆内存）
    if (NULL == extendedProtocolList->extendedProtocolCaches) {
        extendedProtocolList->extendedProtocolCaches =  malloc(sizeof(YSExtendedProtocol));
    } else {
        extendedProtocolList->extendedProtocolCaches =  realloc(extendedProtocolList->extendedProtocolCaches, sizeof(YSExtendedProtocol)*(extendedProtocolList->listLength+1));
    }
    
    // 3.写入新数据
    YSExtendedProtocol *appendExtendedProtocol = extendedProtocolList->extendedProtocolCaches + extendedProtocolList->listLength - 1;
    appendExtendedProtocol->extendedProtocol_free = extendedProtocol_free;
    appendExtendedProtocol->instanceMethodCount = 0;
    appendExtendedProtocol->classMethodCount = 0;

    // 3.1.记录协议（申请YSExtendedProtocol->protocol的堆内存,拷贝）
    // 纠正：此处protocol是OC对象，不需要内存管理
    appendExtendedProtocol->protocol = protocol;

    // 3.2.记录实例方法的默认实现（申请YSExtendedProtocol->instanceMethods的堆内存）
    unsigned defaultInstanceCount = 0;
    Method *defaultInstanceMethods = class_copyMethodList(containerClass, &defaultInstanceCount);
    appendExtendedProtocol->instanceMethodCount = defaultInstanceCount;
    if (defaultInstanceCount > 0) {
        appendExtendedProtocol->instanceMethods = malloc(sizeof(Method)*defaultInstanceCount);
        memcpy(appendExtendedProtocol->instanceMethods, defaultInstanceMethods, sizeof(Method)*defaultInstanceCount);
    } else {
        appendExtendedProtocol->instanceMethods = NULL;
    }    
    
    // 4.记录类方法的默认实现（申请YSExtendedProtocol->classMethods的堆内存）
    unsigned defaultClassCount = 0;
    Method *defaultClassMethods = class_copyMethodList(object_getClass(containerClass), &defaultClassCount);
    appendExtendedProtocol->classMethodCount = defaultClassCount;
    // 由于默认实现了load，这里忽略这个load
    if (defaultClassCount > 0) {
        appendExtendedProtocol->classMethods = malloc(sizeof(Method)*defaultClassCount);
        memcpy(appendExtendedProtocol->classMethods, defaultClassMethods, sizeof(Method)*defaultClassCount);
    } else {
        appendExtendedProtocol->classMethods = NULL;
    }
    
    // 5.内存释放
    free(defaultInstanceMethods);
    free(defaultClassMethods);
}

// 注入默认协议的函数
static void _ys_injectDefaultImpl(Class targetClass, YSExtendedProtocol extendedProtocol) {
    
    // 1.遍历所有默认实例方法实现，然后注入
    for (unsigned index = 0; index < extendedProtocol.instanceMethodCount; ++index) {
        // 1.1.获取方法
        Method instanceMethod = extendedProtocol.instanceMethods[index];
        // 1.2.检测是否已实现,实现则跳过
        SEL selector = method_getName(instanceMethod);
        if (class_getInstanceMethod(targetClass, selector)) continue;
        // 1.3.注入实现
        IMP imp = method_getImplementation(instanceMethod);
        const char *types = method_getTypeEncoding(instanceMethod);
        class_addMethod(targetClass, selector, imp, types);
        // 这个貌似在注册后就无法更改
//        protocol_addMethodDescription (extendedProtocol.protocol, imp, types, BOOL isRequiredMethod, YES);
    }
    
    // 2.遍历所有默认类方法实现，然后注入
    Class targetMetaClass = object_getClass(targetClass);
    for (unsigned index = 0; index < extendedProtocol.classMethodCount; ++index) {
        // 1.1.获取方法
        Method classMethod = extendedProtocol.classMethods[index];
        // 1.2.检测是否已实现,实现则跳过
        SEL selector = method_getName(classMethod);
        if (class_getInstanceMethod(targetClass, selector)) continue;
        // 1.3.屏蔽类生命方法
        if (selector == @selector(load) || selector == @selector(initialize)) continue;
        // 1.4.注入实现
        IMP imp = method_getImplementation(classMethod);
        const char *types = method_getTypeEncoding(classMethod);
        class_addMethod(targetMetaClass, selector, imp, types);
    }
    
}

// runtime之后，在main之前，对遵循协议的类注入实现
__attribute__((constructor)) static void _pk_beforeMain(void) {

    pthread_mutex_lock(&protocolsLoadingLock);
    
    unsigned classCount = 0;
    Class *allClasses = objc_copyClassList(&classCount);
    
    @autoreleasepool {
        if (NULL == extendedProtocolList) return;
        // 遍历缓存的协议链表
        for (unsigned index = 0; index < extendedProtocolList->listLength; ++index) {
            YSExtendedProtocol *extendedProtocol = extendedProtocolList->extendedProtocolCaches + index;
            // 遍历所有类，查看是否有遵循默认协议，有则注入
            for (unsigned index = 1; index < classCount; ++index) {
                Class class = allClasses[index];
                if (!class_conformsToProtocol(class, extendedProtocol->protocol)) {
                    continue;
                }
                // 注入实现
                _ys_injectDefaultImpl(class, *extendedProtocol);
            }
        }
    }
    pthread_mutex_unlock(&protocolsLoadingLock);
    // 释放内存
    free(allClasses);
    // 先析构里面内存
    extendedProtocolList->extendedProtocolList_free(extendedProtocolList);
    free(extendedProtocolList);
    // 置空指针
    extendedProtocolList = NULL;
}












