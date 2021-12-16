//
//  GLWebViewController2.m
//  JavaScriptDemo
//
//  Created by lexandera on 2018/9/30.
//  Copyright © 2018年 历山大亚. All rights reserved.
//

#import "GLWebViewController2.h"
#import <WebKit/WebKit.h>
@interface GLWebViewController2 ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, weak) WKWebView * webView;

@end

@implementation GLWebViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    WKWebView *web = [[WKWebView alloc] initWithFrame:self.view.bounds];
    web.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    web.UIDelegate = self;
    web.navigationDelegate = self;
    web.scrollView.bounces = NO;
    
    _webView = web;
    [self loadRequest];
    [self loadExportObject];
    [self.view addSubview:web];
    
    [self.webView evaluateJavaScript:@"function(1,2)" completionHandler:nil];
    
//    if (@available(iOS 11.0, *)){
//        web.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }else{
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
}


- (void)loadRequest{
//    NSURL *url = [NSURL URLWithString:@"index4.html" relativeToURL:[NSURL URLWithString:@"http://172.16.3.10/"]];
    NSString *str = [[NSBundle mainBundle] pathForResource:@"index2" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:str];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)loadExportObject{
    
    [self.webView evaluateJavaScript:@"closePage" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"closePage"];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"%s",__FUNCTION__);

}

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    if ([message.name isEqualToString:@"closePage"]) {
        NSString * text = message.body;
        NSLog(@"%@",text);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:true];
        });
    }
}

@end
