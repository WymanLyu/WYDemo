//
//  ViewController.m
//  9-8GCDGroup
//
//  Created by wyman on 2017/9/8.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"

#define CHECK_RUNNING if (_isRunning) { \
                        return; \
                        }

@interface ViewController ()


/** 并发组 */
@property (nonatomic, strong) dispatch_group_t group;

/** 并发队列 */
@property (nonatomic, strong) dispatch_queue_t queue;


@property (nonatomic, assign) NSInteger enterCount;

@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, assign) BOOL isWaiting;

@property (nonatomic, strong) dispatch_semaphore_t sema;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _group = dispatch_group_create();
    _queue = dispatch_queue_create([@"test.group" cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_SERIAL);
    _enterCount = 0;
    _isRunning = NO;
    _isWaiting = NO;
    
    _sema = dispatch_semaphore_create(0);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self clean];
    [self task1];
    [self task2];
    [self begin];
    
    // 连续两次，此时clean手动leave并不能立刻触发notify
//    [self clean];
//    [self task1];
//    [self task2];
//    [self begin];

}

- (void)clean {
    NSInteger count = self.enterCount;
    for (int i = 0; i < count; i++) {
        NSLog(@"手动取消任务%zd", i+1);
        dispatch_group_leave(self.group);
        self.enterCount--;
    }
    // 这里要触发notify才行。。。
    if (_isRunning) {
        NSLog(@"等待notify....");
        _isWaiting = YES;
        dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);
        NSLog(@"notify完了啊....");
        _isWaiting = NO;
    }
}

- (void)begin {
    _isRunning = YES;
    dispatch_group_notify(_group, self.queue, ^{
        _isRunning = NO;
        NSLog(@"完毕---enterCount:%zd--thread:%@", _enterCount, [NSThread currentThread]);
        NSLog(@"   ");
        self.enterCount = 0;
        if (_isWaiting) {
            dispatch_semaphore_signal(_sema);
        }
    });
}

- (void)task1 {
    dispatch_group_enter(self.group);
    _enterCount++;
    NSLog(@"提交任务1");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_enterCount) {
            NSLog(@"任务1完毕");
            _enterCount--;
            dispatch_group_leave(self.group);
        }
    });
}

- (void)task2 {
    dispatch_group_enter(self.group);
    _enterCount++;
    NSLog(@"提交任务2");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         if (_enterCount) {
             NSLog(@"任务2完毕");
             _enterCount--;
             dispatch_group_leave(self.group);
         }
    });
}


@end
