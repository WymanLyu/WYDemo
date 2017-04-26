//
//  ViewController.m
//  4-18校验不信任SSL
//
//  Created by wyman on 2017/4/18.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate,NSURLSessionDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController
{
    NSURLRequest *_failedRequest;
    NSURLSessionDataTask *_failedTask;
    BOOL _finishSSL;
    NSURLSession *_urlsession;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://passport.oborttc.com/getuserinfo?token=FLGcNoN4x8nbheCNB6FhN6OxxqxrP4H2kX6aWw1hps6KuHQsJVwTRfDR24UpxKmM"]];
    NSURLSessionConfiguration *con = [NSURLSessionConfiguration defaultSessionConfiguration];
    con.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    _urlsession = [NSURLSession sessionWithConfiguration:con delegate:self delegateQueue:[NSOperationQueue mainQueue]];
     NSURLSessionDataTask *task = [_urlsession dataTaskWithRequest:request completionHandler:^(NSData* _Nullable data, NSURLResponse* _Nullable response, NSError* _Nullable error) {
        NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"-----%@", str);
    }];
    [task resume];
    
    
    
    
    
//    _finishSSL = NO;
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://passport.oborttc.com/getuserinfo?token=FLGcNoN4x8nbheCNB6FhN6OxxqxrP4H2kX6aWw1hps6KuHQsJVwTRfDR24UpxKmM"]]; // https://passport.oborttc.com/login?returnurl=https%3A%2F%2Fwww.baidu.com&view=m
//    [self.webView loadRequest:request];
//    self.webView.delegate = self;
    
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {

    if (_finishSSL != YES) {
        if (!_urlsession) {
            NSURLSessionConfiguration *con = [NSURLSessionConfiguration defaultSessionConfiguration];
            con.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
            _urlsession = [NSURLSession sessionWithConfiguration:con delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//            _urlsession = [NSURLSession sharedSession];
//            _urlsession.delegate = self;
            
            
        }

        NSURLSessionDataTask *task = [_urlsession dataTaskWithRequest:request completionHandler:^(NSData* _Nullable data, NSURLResponse* _Nullable response, NSError* _Nullable error) {
            NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"-----%@", str);
            _finishSSL = YES;
//            [self.webView loadHTMLString:str baseURL:_failedRequest.URL];
//            [self.webView loadData:data MIMEType:<#(nonnull NSString *)#> textEncodingName:<#(nonnull NSString *)#> baseURL:<#(nonnull NSURL *)#>]
            [self.webView loadRequest:_failedRequest];
            [_failedTask cancel];
        }];
//        NSURLSessionDataTask *task = [_urlsession dataTaskWithRequest:request];
        
        _failedTask = task;
        
        _failedRequest = request;
        [task resume];
        return NO;
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    [webView loadRequest:_failedRequest];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
    
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    //判断服务器返回的证书是否是服务器信任的
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
//        disposition：如何处理证书
//         NSURLSessionAuthChallengePerformDefaultHandling:默认方式处理
//         NSURLSessionAuthChallengeUseCredential：使用指定的证书 
//         NSURLSessionAuthChallengeCancelAuthenticationChallenge：取消请求
        // 创建证书
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        if (credential) {
            disposition = NSURLSessionAuthChallengeUseCredential;
             _finishSSL = YES; // SSL证书获取完毕
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
    }
    
    //安装证书
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
   [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
//
    
//    if ([challenge previousFailureCount] == 0)
//    {
//        _finishSSL = YES;
//        
//        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//        
//        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
//        
//    } else
//    {
//        [[challenge sender] cancelAuthenticationChallenge:challenge];
//    }
    
    
}

// 接收到服务器的响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSLog(@"didReceiveResponse");
    completionHandler(NSURLSessionResponseAllow);
}

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host {
    
    return YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
