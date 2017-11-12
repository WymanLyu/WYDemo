//
//  UINavigationController1.m
//  3-10设计要看button
//
//  Created by wyman on 2017/9/29.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "UINavigationController1.h"
#import "UIViewController+TYMediaCenter.h"
#import "UINavigationController+TYMediaCenter.h"
#import <objc/runtime.h>

@interface UINavigationController1 ()


@end

@implementation UINavigationController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self bottomPlayContainView]; // 第一次就加载这个容器视图
    

    NSArray *a = [self propertys];
    NSLog(@"%@", a);
//    self.childViewControllers
    [self addObserver:self forKeyPath:@"childViewControllers" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    
    [self afterCallSuperPush:viewController];

//    // 隐藏控制器栈底的悬浮【本来显示着的隐藏】
//    for (UIView *bottomSubView in self.bottomPlayContainView.subviews) {
//        if (!bottomSubView.hidden) {
//            bottomSubView.hidden = YES;
//            [self.visibleList addObject:bottomSubView];
//        }
//    }
//    // 加载栈顶的悬浮按钮
//    [self.bottomPlayContainView bringSubviewToFront:viewController.bottomPlayView];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
//    [self beforCallSuperPop];
    
//    // 移除现有的
//    [self.bottomPlayContainView.subviews.lastObject removeFromSuperview];
//    // 显示栈顶下面的悬浮按钮【被隐藏了的显示出来】
//    if ([self.visibleList containsObject:self.bottomPlayContainView.subviews.lastObject]) {
//        [self.bottomPlayContainView.subviews.lastObject setHidden:NO];
//    }

    return [super popViewControllerAnimated:animated];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"childViewControllers"]) {
        NSLog(@"---");

    }
}


- (NSArray *)propertys
{
    unsigned int count = 0;
    //获取属性的列表
    objc_property_t *propertyList =  class_copyPropertyList([UINavigationController class], &count);
    NSMutableArray *propertyArray = [NSMutableArray array];
    
    for(int i=0;i<count;i++)
    {
        //取出每一个属性
        objc_property_t property = propertyList[i];
        //获取每一个属性的变量名
        const char* propertyName = property_getName(property);
        
        NSString *proName = [[NSString alloc] initWithCString:propertyName encoding:NSUTF8StringEncoding];
        
        [propertyArray addObject:proName];
    }
    //c语言的函数，所以要去手动的去释放内存
    free(propertyList);
    
    return propertyArray.copy;
}




@end
