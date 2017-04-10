//
//  secureCommunication.h
//  3-29secureTest
//
//  Created by wyman on 2017/3/29.
//  Copyright © 2017年 playerTest. All rights reserved.
//

#ifndef secureCommunication_h
#define secureCommunication_h

#ifndef MAX_MSG
#define MAX_MSG 100
#endif

typedef long long longInt;

#pragma mark - 数据结构

// 密钥
typedef struct
{
    longInt m;
    longInt n;
}key_point;

typedef struct
{
    key_point publicKey;
    key_point privateKey;
    
}rsa_key;

// 服务器数据结构
struct server_struct
{
    // 发送文本
    char msg[MAX_MSG];
    // 发送数字
    int msgNumber;
    // 密钥
    int key;
    // rsa私钥
    key_point privateKey;
    // 加密文本
    void (*encrypt_function_p)(char *, int);
};
typedef struct server_struct server_struct;


// 客户端数据结构
struct client_struct
{
    // 接受文本
    char msg[MAX_MSG];
    // 接受数字
    int msgNumber;
    // 密钥
    int key;
    // 公钥
    key_point publicKey;
    // 解密文本
    void (*decrypt_function_p)(char *, int);
};
typedef struct client_struct client_struct;

#pragma mark - 对称加密
// 加密
extern void encrypt_function(char *msg, int key);
// 解密
extern void decrypt_function(char *msg, int key);

#pragma mark - 非对称加密
// 生成密钥
extern rsa_key creat_rsa_key(longInt p, longInt q);
// 加密
extern longInt encrypt_rsa_function(int msg, key_point publickey);
// 解密
extern longInt decrypt_rsa_function(int msg, key_point privatekey);


#pragma mark - 网络传输
extern char *send_msg_2_client(char *msg, int msgCount);
extern void send_msg_2_client_number(int msg);


#endif /* secureCommunication_h */
