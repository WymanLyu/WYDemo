//
//  TestController.m
//  12-12WYEvent
//
//  Created by wyman on 2016/12/21.
//  Copyright © 2016年 tykj. All rights reserved.
//

#import "TestController1.h"

@interface TestController1 ()
@property (weak, nonatomic) IBOutlet UILabel *valueLbl;

@end

@implementation TestController1


- (void)dealloc {
    NSLog(@"%s", __func__);
//    [WYEventCenter wy_removeHandingEvent:@"ssss"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    __weak typeof(self)weakSelf = self;
    // 虽然不会循环引用，但是self使用weak还是必要的因为block对self引用了
    [self wy_observeHandingEvent:@"CustomViewSliderChange" handle:^(id noti, __autoreleasing id *re) {
        *re = @(88888);
        weakSelf.valueLbl.text = [noti stringValue];
        NSLog(@"--%@ 控制器执行中。。。", noti);
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
