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

#import "TestBindView.h"
#import "TestBindModel.h"

@interface TestController3 ()

@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) IBOutlet UILabel *lbl;

@property (nonatomic, strong) TestBindModel *bindmodel;
@property (nonatomic, strong) TestBindView *bindview;

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
    
    _bindmodel = [TestBindModel new];
    _bindview = [[TestBindView alloc] initWithFrame:CGRectMake(0, 300, 200, 200)];
    _bindview.backgroundColor = [UIColor yellowColor];
    _bindview.model = _bindmodel;
    [self.view addSubview:_bindview];
    
    __weak typeof(self)weakSelf = self;
    [self wy_observePath:@"value" target:self.slider options:NSKeyValueObservingOptionNew change:^(NSDictionary<NSKeyValueChangeKey,id> *change) {
        NSLog(@"====");
        NSString *newValue = [[change objectForKey:NSKeyValueChangeNewKey] stringValue];
        weakSelf.lbl.text = newValue;
        weakSelf.bindmodel.price = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
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
