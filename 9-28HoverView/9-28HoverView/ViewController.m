//
//  ViewController.m
//  9-28HoverView
//
//  Created by wyman on 2017/9/28.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "UIView1.h"
#import "UIView2.h"
#import "UIView3.h"

@interface ViewController ()
//create a readonly property selectionCount
@property (nonatomic, readonly)NSInteger selectionCount;

@end

@implementation ViewController

//Implement the getter method
-(NSInteger)selectionCount{
    return self.view.subviews.count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *v = [UIView new];
    
    [self.view addSubview:v];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selectionCount"]) {
        NSLog(@"%@ -- %@", [change objectForKey:NSKeyValueChangeNewKey], [change objectForKey:NSKeyValueChangeOldKey]);
    }
}


@end
