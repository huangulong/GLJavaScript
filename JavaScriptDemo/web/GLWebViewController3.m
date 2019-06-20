//
//  GLWebViewController3.m
//  JavaScriptDemo
//
//  Created by lexandera on 2018/10/16.
//  Copyright © 2018年 历山大亚. All rights reserved.
//

#import "GLWebViewController3.h"
#import "UIViewController+Alert.h"

@interface GLWebViewController3 ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView * webView;

@end

//重定向
@implementation GLWebViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"click" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightClick:)];
    [self loadRequest];
}

- (IBAction)rightClick:(id)sender{
    NSString * js = @"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ocmethod(){" //添加函数 到‘}’结束
    "window.location.href = 'xueleapp://message?mid=2222222';"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    
    //写入js方法
    [self.webView stringByEvaluatingJavaScriptFromString:js];
}

- (void)loadRequest{
    NSString *str = [[NSBundle mainBundle] pathForResource:@"index4" ofType:@"html"];
    NSURL *url = [NSURL URLWithString:str];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString * s = request.URL.scheme;
    if ([s isEqualToString:@"xueleapp"]) {
        [self showMessage:request.URL.absoluteString];
        
        //oc 调用 js的方法
//        NSString * js = [NSString stringWithFormat:@"alert('%@');",request.URL.absoluteString];
//        [self.webView stringByEvaluatingJavaScriptFromString:js];
        
        return NO;
    }
    return YES;
}

#pragma mark - getter
- (UIWebView *)webView{
    if (_webView == nil) {
        UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.bounds];
        web.delegate = self;
        [self.view addSubview:web];
        _webView = web;
    }
    return _webView;
}

@end
