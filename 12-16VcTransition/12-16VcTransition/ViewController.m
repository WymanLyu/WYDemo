//
//  ViewController.m
//  12-16VcTransition
//
//  Created by wyman on 2016/12/16.
//  Copyright © 2016年 tykj. All rights reserved.
//

#import "ViewController.h"
#import "TransitionViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *blurView;

@property (nonatomic, weak) CAGradientLayer *layerT;
@property (nonatomic, weak) CAGradientLayer *layerB;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UINib *nib = [UINib nibWithNibName:@"MainTableViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MainTableViewCell"];
}

- (BOOL)prefersStatusBarHidden {
    　　return YES; // 返回NO表示要显示，返回YES将hiden
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"MainTableViewCell"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 234;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 获取位置
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    // 转换
    CGRect rectInWindow = [tableView convertRect:rectInTableView toView:self.view];
    
    // 加个阴影吧
    [self.layerT removeFromSuperlayer];
    [self.layerB removeFromSuperlayer];
    CAGradientLayer *layerT = [CAGradientLayer layer];
    layerT.colors = @[(id)[UIColor clearColor].CGColor,(id)[[UIColor blackColor]colorWithAlphaComponent:0.65].CGColor];
    layerT.locations = @[@(0.5),@(1.0)];
    layerT.bounds = CGRectMake(0, 0, rectInTableView.size.width, 234*2);
    layerT.anchorPoint = CGPointMake(0, 1);
    layerT.position = rectInTableView.origin;
    [self.tableView.layer addSublayer:layerT];
    self.layerT = layerT;
    
    CAGradientLayer *layerB = [CAGradientLayer layer];
    layerB.colors = @[(id)[[UIColor blackColor] colorWithAlphaComponent:0.65].CGColor,(id)[UIColor clearColor].CGColor];
    layerB.locations = @[@(0),@(0.5)];
    layerB.bounds = CGRectMake(0, 0, rectInTableView.size.width, 234*2);
    layerB.anchorPoint = CGPointMake(0, 0);
    layerB.position = CGPointMake(0, rectInTableView.origin.y+ rectInTableView.size.height);
    [self.tableView.layer addSublayer:layerB];
    self.layerB = layerB;
    
    TransitionViewController *vc = [[TransitionViewController alloc] init];

    // 保留在window上
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.rectInWindow = ^CGRect  {
        return rectInWindow;
    };
    // 这就是懒加载的不好了。。。蛋疼
    [vc view];

    [self presentViewController:vc animated:YES completion:^{
        [self.layerT removeFromSuperlayer];
        [self.layerB removeFromSuperlayer];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
    
}


@end
