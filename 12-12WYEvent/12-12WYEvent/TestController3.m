//
//  TestController3.m
//  12-12WYEvent
//
//  Created by wyman on 2017/2/10.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import "TestController3.h"
#import "WYEvent.h"
#import "WYKVOCourier.h"

@interface TestController3 ()
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) IBOutlet UILabel *lbl;

@end

static id obj = nil;

@implementation TestController3

- (void)dealloc {
    NSLog(@"%s", __func__);
//    无需移除
//    [self.slider removeObserver:[WYKVOCourier shareCourier] forKeyPath:@"value"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    obj = [NSObject new];
    __weak typeof(self)weakSelf = self;
    [self wy_observePath:@"value" target:self.slider options:NSKeyValueObservingOptionNew change:^(NSDictionary<NSKeyValueChangeKey,id> *change) {
        NSLog(@"====");
        NSString *newValue = [[change objectForKey:NSKeyValueChangeNewKey] stringValue];
        weakSelf.lbl.text = newValue;
        
    }];
    
//    [self.slider addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
    
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    NSLog(@"--");
//    NSString *newValue = [[change objectForKey:NSKeyValueChangeNewKey] stringValue];
//    self.lbl.text = newValue;
//}

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
