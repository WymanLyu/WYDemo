//
//  ViewController.m
//  3-10设计要看button
//
//  Created by wyman on 2017/3/10.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "ViewController1.h"
#import "ViewController2.h"
#import "UIViewController+TYMediaCenter.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *hahah;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.hahah.layer.borderColor = [UIColor redColor].CGColor;
    self.hahah.layer.borderWidth = 5;
    self.bottomPlayView.hidden = NO;
    [self.view.layer addObserver:self forKeyPath:@"sublayers" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"sublayers"]) {
        NSArray *newSublayers = (NSArray *)[change objectForKey:NSKeyValueChangeNewKey];
        NSArray *oldSublayers = (NSArray *)[change objectForKey:NSKeyValueChangeOldKey];
        if (newSublayers.count > oldSublayers.count) {
            NSLog(@"增加了视图...");
        } else {
            NSLog(@"减少了视图...");
        }
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    ViewController1 *v =[[ViewController1 alloc] init];
    [self.navigationController pushViewController:v animated:YES];
}


- (IBAction)add:(id)sender {
    UIView *v = [UIView new];
    v.frame = CGRectMake(100, 230, 33, 44);
    v.backgroundColor = [UIColor redColor];
    [self.view addSubview:v];
}
- (IBAction)move:(id)sender {
    [self.view.subviews.lastObject removeFromSuperview];
}

@end
