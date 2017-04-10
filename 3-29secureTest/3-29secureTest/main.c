//
//  main.c
//  3-29secureTest
//
//  Created by wyman on 2017/3/29.
//  Copyright © 2017年 playerTest. All rights reserved.
//

#include <stdio.h>
#include "secureCommunication.h"

int main(int argc, const char * argv[]) {
    
    // rsa生成公钥私钥
    rsa_key rsa = creat_rsa_key(3, 11);
    printf("public=(%lld, %lld) private=(%lld, %lld)\n", rsa.publicKey.m, rsa.publicKey.n, rsa.privateKey.m, rsa.privateKey.n);
    printf("---------------------------\n");
    
    // 创建服务端
    server_struct server;
    server.msg[0] = 'H';
    server.msg[1] = 'e';
    server.msg[2] = 'l';
    server.msg[3] = 'l';
    server.msg[4] = 'o';
    server.msg[5] = '\0';
    server.key = 2;
    server.msgNumber = 24;
    server.privateKey = rsa.privateKey;
    server.encrypt_function_p = encrypt_function;
    
    // 创建客户端
    client_struct client;
    client.key = 2;
    client.publicKey = rsa.publicKey; // 这一步需要使用证书
    client.decrypt_function_p = decrypt_function;
    
    // 加密
    printf("服务器发送前未加密%s-%d\n", server.msg, server.msgNumber);
    server.encrypt_function_p(server.msg, server.key);
    longInt codeMsgNumber = encrypt_rsa_function(server.msgNumber, server.privateKey);
    printf("服务器发送前加密%s-%lld\n", server.msg, codeMsgNumber);
    
    printf("---------------------------\n");
    // 网络发送
    char *receive_msg = send_msg_2_client(server.msg, (int)codeMsgNumber);
    printf("---------------------------\n");
    
    // 客户端接受
    client.msg[0] = receive_msg[0];
    client.msg[1] = receive_msg[1];
    client.msg[2] = receive_msg[2];
    client.msg[3] = receive_msg[3];
    client.msg[4] = receive_msg[4];
    client.msg[5] = receive_msg[5];
    client.msgNumber = (int)codeMsgNumber;
    // 客户端解密
    printf("客户端接受后未解密%s-%d\n", client.msg, client.msgNumber);
    client.decrypt_function_p(client.msg, client.key);
    longInt unCodeMsgNumber = decrypt_rsa_function(client.msgNumber, client.publicKey);
    printf("客户端接受后解密%s-%lld\n", client.msg, unCodeMsgNumber);
    printf("---------------------------\n");
    return 0;
}
