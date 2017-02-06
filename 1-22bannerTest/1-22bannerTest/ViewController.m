//
//  ViewController.m
//  1-22bannerTest
//
//  Created by wyman on 2017/1/22.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import "ViewController.h"
#import "WYMagicBanner.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate >

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    WYMagicBanner *banner = [[WYMagicBanner alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
    banner.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:banner];
    
    
    NSArray *imgArray = @[@"http://o9kbeutq6.bkt.clouddn.com/image/ad/%E4%B8%BB%E9%A2%981.png",
                         @"http://o9kbeutq6.bkt.clouddn.com/image/ad/%E4%B8%BB%E9%A2%982.png",
                         @"http://o9kbeutq6.bkt.clouddn.com/image/ad/%E4%B8%BB%E9%A2%983.png",
                         @"http://o9kbeutq6.bkt.clouddn.com/image/ad/%E4%B8%BB%E9%A2%984.png"];
    banner.imageURLStringsGroup = imgArray;
    
    
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    testBtn.frame = CGRectMake(0, 365, 44, 44);
    [testBtn addTarget:self action:@selector(testBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
    
//    self.view.backgroundColor = [UIColor blackColor];
    UIImageView *bgImgView = [UIImageView new];
    bgImgView.image = [UIImage imageNamed:@"bg.png"];
    bgImgView.backgroundColor = [UIColor redColor];
    bgImgView.userInteractionEnabled =YES;
    bgImgView.frame = self.view.frame;
    [self.view addSubview:bgImgView];
    
    
    UIImageView *bgView = [UIImageView new];
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = [UIColor clearColor];
    bgView.frame = CGRectMake(10, 320, [UIScreen mainScreen].bounds.size.width-20, 400);
    [self.view addSubview:bgView];

//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width-40, 300)];
    UITableView *tableView = [[UITableView alloc] initWithFrame:bgView.bounds];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    [bgView addSubview:tableView];
    
    // 渐变
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = bgView.bounds;
    gradientLayer.colors = @[(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.01].CGColor,(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor, (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor];
    gradientLayer.locations = @[@(0),@(0.1), @(0.3), @(1)];
    bgView.layer.mask = gradientLayer;
    
    
    
    self.dataSource = @[@"sds", @"sasdskjdlk", @"来个中文？", @"dwhdiuwhdoiw", @"sasdSHUQHskjdlk", @"WDW来个中文WSW", @"dwhdiuwZHENGEG SQhdoiw", @"sasdskjdlk", @"来个中文？", @"dwhdiuwhdoiw", @"sasdSHUQHskjdlk", @"sasdskjdlk", @"来个中文？", @"dwhdiuwhdoiw", @"sasdSHUQHskjdlk"];
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"UITableViewCell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor]; //[UIColor  colorWithRed:0 green:1 blue:0 alpha:0.2];
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
    
}


- (void)testBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
