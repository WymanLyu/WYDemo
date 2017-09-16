//
//  ViewController1.m
//  SimpleNavigationBar
//
//  Created by wyman on 2017/9/12.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController1.h"
#import "ViewController2.h"
#import "ViewController3.h"

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ViewController1";
    self.view.backgroundColor = [UIColor lightGrayColor];

    
    UIButton *btn = [UIButton new];
    [btn setTitle:@"原生push到透明" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click1) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn2 = [UIButton new];
    [btn2 setTitle:@"原生push到蓝色" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(click2) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:btn];
    [self.view addSubview:btn2];
    
    btn.frame = CGRectMake(100, 120, 155, 66);
    btn2.frame = CGRectMake(100, 220, 155, 66);
    
}

- (void)click1 {
    ViewController2 *v = [ViewController2 new];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)click2 {
    ViewController3 *v = [ViewController3 new];
    [self.navigationController pushViewController:v animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    FuncLog
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    FuncLog
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    self.navigationItem.prompt = @"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [UITableViewCell new];
//}

@end
