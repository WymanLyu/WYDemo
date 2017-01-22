//
//  WYServer.m
//  05-16SocketDemoServer
//
//  Created by sialice on 16/5/16.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYServer.h"
#import "GCDAsyncSocket.h"

@interface WYServer()<GCDAsyncSocketDelegate>

/** 服务端socket / 负责监听客户端socket */
@property (strong, nonatomic) GCDAsyncSocket *serverSocket;

/** 客户端socket的数组 */
@property (strong, nonatomic) NSMutableArray *clientSockets;

@end

@implementation WYServer

- (NSMutableArray *)clientSockets {
    if (!_clientSockets) {
        _clientSockets = [NSMutableArray array];
    }
    return _clientSockets;
}

// 开启监听
- (void)start{
    // 1.创建服务端Socket对象并设置监听代理
    GCDAsyncSocket *serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    
    // 2.绑定并监听端口号
    NSError *error;// 端口已经被占用的时候会有错误
    [serverSocket acceptOnPort:5288 error:&error];
    if (error) {
        NSLog(@"%@",error);
    }else{
        NSLog(@"服务开启成功");
    }
    
    // 3.强引用
    self.serverSocket = serverSocket;
}


#pragma mark - GCDAsyncSocketDelegate

/** 客户端连接时调用 */
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    
    // 1.保存客户端的Socket对象
    [self.clientSockets addObject:newSocket]; // 可使用终端测试
    NSLog(@"当前连接的客户端数量:%zd 新IP:%@",self.clientSockets.count, newSocket.connectedHost);
    
    // 2.监听客户端socket数据的读取
    [newSocket readDataWithTimeout:-1 tag:0];
}

/** 接收到客户端socket的数据 */
-(void)socket:(GCDAsyncSocket *)clientSocket didReadData:(NSData *)data withTag:(long)tag{
 
    // 1.解析数据 / 测试数据
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"接收到客户端的数据: %@",str);
    
    // 2.转发给客户端（作为1:N的聊天）
    for (GCDAsyncSocket *socket in self.clientSockets) {
        if (socket != clientSocket) { // 非发送者
            [socket writeData:data withTimeout:-1 tag:0];
        }
    }
    
    // 3.再次监听数据的读取
    [clientSocket readDataWithTimeout:-1 tag:0];

}


@end
