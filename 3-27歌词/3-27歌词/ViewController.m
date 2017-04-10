//
//  ViewController.m
//  3-27歌词
//
//  Created by wyman on 2017/3/27.
//  Copyright © 2017年 playerTest. All rights reserved.
//

#import "ViewController.h"
#import "YSSongLrcLine.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    NSString *str= @"[00:03.034]我是自贡人，不是职工人\r\n[00:07.063]说话平胜桥是不对哒腾腾\r\n[00:11.091]算了算了算了，反正你都转了，我说分手你还高兴，早点帮我换了我揍，我揍，我这还这样做？\r\n[00:20.049]我是自贡人，不是职工人\r\n[00:24.077]说话平胜桥是不对哒腾腾\r\n[00:26.092]算了算了算了，反正你都转了，我说分手你还高兴，早点帮我换了我揍，我揍，我这还这样做？\r\n[00:35.049]我是自贡人，不是职工人\r\n[00:39.077]说话平胜桥是不对哒腾腾\r\n[00:44.006]算了算了算了，反正你都转了，我说分手你还高兴，早点帮我换了我揍，我揍，我这还这样做？\r\n[00:52.063]我是自贡人，不是职工人\r\n[00:56.092]说话平胜桥是不对哒腾腾\r\n[01:03.034]算了算了算了，反正你都转了，我说分手你还高兴，早点帮我换了我揍，我揍，我这还这样做？\r\n[01:16.020]我是自贡人，不是职工人\r\n[01:19.095]说话平胜桥是不对哒腾腾\r\n[01:24.024]算了算了算了，反正你都转了，我说分手你还高兴，早点帮我换了我揍，我揍，我这还这样做？\r\n[01:38.016]我是自贡人，不是职工人\r\n[01:42.045]说话平胜桥是不对哒腾腾\r\n[01:46.020]算了算了算了，反正你都转了，我说分手你还高兴，早点帮我换了我揍，我揍，我这还这样做？\r\n[01:50.048]我是自贡人，不是职工人\r\n[01:54.023]说话平胜桥是不对哒腾腾\r\n[01:58.052]算了算了算了，反正你都转了，我说分手你还高兴，早点帮我换了我揍，我揍，我这还这样做？\r\n[02:12.044]我是自贡人，不是职工人\r\n[02:16.073]说话平胜桥是不对哒腾腾\r\n[02:20.048]算了算了算了，反正你都转了，我说分手你还高兴，早点帮我换了我揍，我揍，我这还这样做？\r\n[02:24.076]我是自贡人，不是职工人\r\n[02:28.051]说话平胜桥是不对哒腾腾\r\n[02:32.080]算了算了算了，反正你都转了，我说分手你还高兴，早点帮我换了我揍，我揍，我这还这样做？\r\n[02:46.072]我是自贡人，不是职工人\r\n[02:51.001]说话平胜桥是不对哒腾腾\r\n[02:54.076]算了算了算了，反正你都转了，我说分手你还高兴，早点帮我换了我揍，我揍，我这还";
    NSArray *lrcArray = [str componentsSeparatedByString:@"\r\n"];
    for (NSString *lineLrc in lrcArray) {
        // 转歌词模型
        YSSongLrcLine *lrcLine = [YSSongLrcLine songLrcLineWithString:lineLrc];
        NSLog(@"%@", lrcLine);
    }
//    YSSongLrcLine *line = [YSSongLrcLine songLrcLineWithString:str];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
