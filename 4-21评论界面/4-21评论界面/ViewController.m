//
//  ViewController.m
//  4-21评论界面
//
//  Created by wyman on 2017/4/21.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "YSCommendReplyView.h"
#import "WYTextView.h"
#import "YZInputView.h"
#import "WYTextView2.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) WYTextView *inputView;

@end



@implementation ViewController
{
    UIImageView *_imgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:0];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    WYTextView *inputView = [[WYTextView alloc] initWithFrame: CGRectMake(0, [UIScreen mainScreen].bounds.size.height-464, [UIScreen mainScreen].bounds.size.width*0.5, 32)];
    [self.view addSubview:inputView];
    inputView.backgroundColor = [UIColor grayColor];
    inputView.font = [UIFont systemFontOfSize:16.0f];
//    inputView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-64, [UIScreen mainScreen].bounds.size.width*0.5, 36);
    self.inputView= inputView;
//    inputView.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight) {
//        
//        CGFloat n =  textHeight+10 -self.inputView.frame.size.height;
//        self.inputView.frame = CGRectMake(self.inputView.frame.origin.x, self.inputView.frame.origin.y-n, self.inputView.frame.size.width, textHeight+10);
//        
//        
//    };
    
    [self songLrcLineWithString:@"[00:11.091]算了算了算了，反正你都转了，我说分手你还高兴，早点帮我换了我揍，我揍，我这还这样做？{01020002}"];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xx"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xx"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row];
    return cell;
}






#pragma mark - ---------------------------
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.15 animations:^{
        CGRect b = _imgView.bounds;
        b = CGRectMake(0, 0, _imgView.bounds.size.width*1.15, _imgView.bounds.size.height*1.15);
        _imgView.bounds = b;
    }];
}


- (void)test {
    // Do any additional setup after loading the view, typically from a nib.
    
    //    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:0];
    //    tableView.delegate = self;
    //    tableView.dataSource = self;
    //    [self.view addSubview:tableView];
    //
    //    YSCommendReplyView *replyView = [YSCommendReplyView new];
    //    replyView.frame = CGRectMake(0, self.view.bounds.size.height-64, self.view.bounds.size.width, 64);
    //    [replyView animateShowOptionView2ReplyView:YES];
    //    [self.view addSubview:replyView];
    
    self.view.backgroundColor = [UIColor redColor];
    
    UILabel *lbl = [UILabel new];
    lbl.font = [UIFont systemFontOfSize:11.0];
    lbl.text = @"放大缩小";
    [lbl sizeToFit];
    
    UIGraphicsBeginImageContext(lbl.bounds.size);
    [lbl.text drawAtPoint:CGPointZero withAttributes:nil];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.frame = CGRectMake(200, 130, lbl.bounds.size.width, lbl.bounds.size.height);
    [self.view addSubview:imgView];
    _imgView = imgView;
    _imgView.layer.borderColor = [UIColor yellowColor].CGColor;
    _imgView.layer.borderWidth = 2;
}


- (void)songLrcLineWithString:(NSString *)lrcLineString {
//    YSSongLrcLine *lrcLine = [YSSongLrcLine new];
    
    // 解析歌词
    // [00:11.091]算了算了算了，反正你都转了，我说分手你还高兴，早点帮我换了我揍，我揍，我这还这样做？
    // 匹配时间
    NSString *pattern = @"^\\[.*\\]";
    // 创建正则表达
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    //查找第一个匹配结果，如果查找不到的话match会是nil
    NSTextCheckingResult *match = [regex firstMatchInString:lrcLineString
                                                    options:NSMatchingReportCompletion
                                                      range:NSMakeRange(0, [lrcLineString length])];
    if (match) {
        // 时间
        //        NSLog(@"%@",[lrcLineString substringWithRange:NSMakeRange(1, match.range.length-2)]);
        // 歌词
        //        NSLog(@"%@",[lrcLineString substringWithRange:NSMakeRange(match.range.length, [lrcLineString length]-match.range.length)]);
        
        if (match.range.length-2) {
            NSString *timeStr = [lrcLineString substringWithRange:NSMakeRange(1, match.range.length-2)];
            NSLog(@"%@",[lrcLineString substringWithRange:NSMakeRange(1, match.range.length-2)]);
//            lrcLine.beginTime = [self convertSting2Time:timeStr];
        }
        if ([lrcLineString length]-match.range.length) {
//            lrcLine.lrcLineText = [lrcLineString substringWithRange:NSMakeRange(match.range.length, [lrcLineString length]-match.range.length)];
            NSLog(@"%@",[lrcLineString substringWithRange:NSMakeRange(match.range.length, [lrcLineString length]-match.range.length)]);
        }
    }
//    return lrcLine;
}


@end
