//
//  AppDelegate.m
//  WYPushDemo
//
//  Created by yunyao on 16/7/12.
//  Copyright © 2016年 yunyao. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1.注册本地通知
    if ([UIDevice currentDevice].systemVersion.doubleValue > 8.0) { // 8.0+版本
        // 1.1.本地通知
        [self registerLocalNoti];
        
    }else{ // 7.0
        
    }
    
    // 2.处理在通过通知启动
    if (launchOptions[@"UIApplicationLaunchOptionsLocalNotificationKey"]) {
        // 2.1.获取启动通知
        UILocalNotification *localNoti = launchOptions[@"UIApplicationLaunchOptionsLocalNotificationKey"];
        // 2.2.处理通知
        [self handleLaunchingByReceiveNoti:localNoti];
    }
    
    return YES;
}

// 接收到通知的处理(程序已死)
- (void)handleLaunchingByReceiveNoti:(UILocalNotification *)localNoti{
    
}

// 接收本地通知的回调(程序未死)
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"%@", notification.alertBody);
    if(application.applicationState == UIApplicationStateActive){// 前台
        NSLog(@"在前台");
    }else if (application.applicationState == UIApplicationStateInactive){ // 进入前台
        NSLog(@"进入前台");
    }
    
}

// 处理操作项
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    NSLog(@"%@", identifier);
    completionHandler();
    
}


// 注册本地通知
- (void)registerLocalNoti {
    // 1.设置通知的操作组
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = @"categoryID";
    // 1.1.操作组的行为
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = @"action1"; // 必须要有key，不然系统没办法找到这个操作
    action1.title = @"这是操作1";
    action1.activationMode = UIUserNotificationActivationModeForeground;
    // 1.2.操作组的行为
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
    action2.identifier = @"action2";
    action2.title = @"这是操作2";
    action2.activationMode = UIUserNotificationActivationModeBackground;
    [category setActions:@[action1, action2] forContext:UIUserNotificationActionContextMinimal];
    
    // 2.创建配置
    NSSet *set = [NSSet setWithObjects:category, nil];
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:set];
    // 3.注册通知
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

// 进入前台
- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
}



@end
