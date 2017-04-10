
#include <stdio.h>
#include <math.h>
#include "secureCommunication.h"

#pragma mark - 对称加密
extern void encrypt_function(char *msg, int key)
{
	while(*msg != '\0') {
		*msg += key;
		msg++;
	}
}

extern void decrypt_function(char *msg, int key)
{
	while(*msg != '\0') {
		*msg -= key;
		msg++;
	}
}

#pragma mark - 非对称加密
// 扩展欧几里得算法
// 返回最大公约数
longInt e_gcd(longInt a, longInt b, longInt *x, longInt *y)
{
    if (0 == b) {
        *x = 1;
        *y = 0;
        return a;
    }
    longInt ans = e_gcd(b, a%b, x, y);
    longInt temp = *x;
    *x = *y;
    *y = temp - (a/b)*(*y);
    return ans;
}

int gcd(int a,int b)
{
    if(b==0)return a;
    
    else return gcd(b,a%b);
}

// 生成密钥
// (n, e) / (n, d)
extern rsa_key creat_rsa_key(longInt p, longInt q)
{
    // 计算N
    longInt n = p*q;
    // 计算欧拉数
    longInt euler = (p-1)*(q-1);
    // 获取公钥e -> 随机<n的自然数 此处就约定为n/2
    longInt e = 3;//euler / 2;
    // 计算私钥的d  e*d + euler*k = 1 这个两元一次方程
    longInt d;
    longInt k;
// #warning 计算两元一次有问题 除以s
    e_gcd(e, euler, &d, &k);
    int s = gcd((int)e, (int)euler);
    d = d / s;
    k = k / s;
    // 初始化公钥 私钥匙
    rsa_key rsaKey;
    rsaKey.publicKey = (key_point){n, e};
    rsaKey.privateKey = (key_point){n, d}; // 7
    return rsaKey;
}

longInt candp(longInt a,longInt b,longInt c)
{
    longInt r = 1;
    b = b + 1;
    while(b!=1)
    {
        r = r*a;
        r = r%c;
        b--;
    }
    return r;
}

// 加密
extern longInt encrypt_rsa_function(int msg, key_point publickey)
{
    return candp(msg, publickey.n, publickey.m);
}

// 解密
extern longInt decrypt_rsa_function(int msg, key_point privatekey)
{
    return candp(msg, privatekey.n, privatekey.m);
}

#pragma mark - 网络传输
extern char *send_msg_2_client(char *msg, int msgCount)
{
    printf("网络中拦截的%s-%d\n", msg, msgCount);
    return msg;
}

extern void send_msg_2_client_number(int msg)
{
    printf("网络中拦截的%d\n", msg);
}
