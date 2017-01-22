//
//  ViewController.m
//  WYSocketClientDemo
//
//  Created by sialice on 16/5/16.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"

// key
static NSString *MessageTypeSendKey = @"MessageTypeSendKey";// 发送消息
static NSString *MessageTypeReceiveKey = @"MessageTypeReceiveKey";// 接收消息

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, GCDAsyncSocketDelegate>

/** 客户端socket */
@property (nonatomic, strong) GCDAsyncSocket *socket;

/** 输入框 */
@property (weak, nonatomic) IBOutlet UITextField *textField;

/** 内容tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 聊天内容 */
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *contentsArrM;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSMutableArray *)contentsArrM {
    if (_contentsArrM == nil) {
        _contentsArrM = [NSMutableArray array];
    }
    return _contentsArrM;
}

/** 连接服务器 */
- (IBAction)connectServer:(UIButton *)sender {
    // 1.创建socket
    GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    self.socket = socket;
    
    // 2.请求连接
    NSString *host = @"192.168.0.103"; // IP
    int port = 5288; // 端口
    NSError *err = nil;
    [self.socket connectToHost:host onPort:port error:&err];
    if (!err) {
        NSLog(@"连接请求已经发送成功...");
    }else{
        NSLog(@"%@",err);
    }

}

/** 发送消息 */
- (IBAction)sendMsg:(UIButton *)sender {
    
    // 1.获取文本
    NSString *sendStr = self.textField.text;
    if (!sendStr.length) return;
    
    // 2.插入数据/刷新表格
    [self.contentsArrM addObject:@{MessageTypeSendKey : sendStr}];
    [self.tableView reloadData];
    
    // 3.发送服务器
    [self.socket writeData:[sendStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    self.textField.text = nil;
}

#pragma mark - GCDAsyncSocketDelegate

/** 连接成功回调 */
-(void)socket:(GCDAsyncSocket *)clientSocket didConnectToHost:(NSString *)host port:(uint16_t)port{
    NSLog(@"与服务器连接成功");
    
    // 监听数据读取
    [clientSocket readDataWithTimeout:-1 tag:0];
}

/** 连接失败回调 */
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    NSLog(@"与服务器连接失败%@",err);
}


/** 获取服务器数据 */
-(void)socket:(GCDAsyncSocket *)clientSocket didReadData:(NSData *)data withTag:(long)tag{
    
    // 1.获取数据 data - > string
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self.contentsArrM addObject:@{MessageTypeReceiveKey : str}];
    
    // 2.刷新表格
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
    
    // 3.监听数据读取
    [clientSocket readDataWithTimeout:-1 tag:0];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentsArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.创建cell
    static NSString *ID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:ID];
    }
    
    // 2.设置数据
    NSDictionary *dict = self.contentsArrM[indexPath.row];
    if (dict[MessageTypeReceiveKey]) { // 接收信息
        cell.textLabel.text = [NSString stringWithFormat:@"其他人:%@", dict[MessageTypeReceiveKey]];
    }else { // 发送信息
        cell.textLabel.text = [NSString stringWithFormat:@"我:%@", dict[MessageTypeSendKey]];
    }
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}













@end
