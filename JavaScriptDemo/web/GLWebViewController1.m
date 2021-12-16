//
//  GLWebViewController.m
//  JavaScriptDemo
//
//  Created by lexandera on 2018/9/10.
//  Copyright © 2018年 历山大亚. All rights reserved.
//

#import "GLWebViewController1.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "UIWebView+JavaScript.h"
@protocol GLExport<JSExport>

- (void)openLocal;

- (NSString *)getToken;
JSExportAs
(sum  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
 - (void)ocSum:(NSInteger)a :(NSInteger)b
 );

- (void)add:(NSInteger)a :(NSInteger)b;

- (NSInteger)mmm;

@end

@protocol GLExport2<JSExport>

- (void)export2Test;

@end


/**
 说明
 UIWebView 上存在一个_UIWebViewScrollView视图对象 变量名为scrollView ， 该视图继承自UIScrollView
 scrollView 视图用于滚动 缩放
 scrollView 存在一个UIWebBrowserView视图对象 和两个滑轮对象(UIImageView)
 UIWebBrowserView  该视图类主要用于渲染HTML 及文本内容的，渲染完后会将具体宽高传递给scrollView，使scrollView 的contentSize 改变，从而产生滚动效果
 oc js交互时，得注意内存问题
 强引用 弱引用，垃圾回收机制
 */
@interface GLWebViewController1 ()<UIWebViewDelegate,GLExport>

@property (nonatomic, weak) UIWebView * webView;

@end

@implementation GLWebViewController1

- (void)dealloc{
    [self.webView removeFromHashTable];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.webView loadre
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"right" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightClick:)];
    
    NSArray * cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    NSLog(@"cookie = %@",cookies);
    for (NSHTTPCookie * cookie in cookies) {
        NSLog(@"cookie -- %@",cookie.properties);
    }
    [self loadRequest];

}

- (IBAction)rightClick:(id)sender{
    [self.webView stringByEvaluatingJavaScriptFromString:@"var arr = ['mm','12'];"];
    void(^ok)(void) = ^{
        [self.view setBackgroundColor:[UIColor whiteColor]];
    };
    ok();
}

- (void)loadRequest{
//    NSURL *url = [NSURL URLWithString:@"index3.html" relativeToURL:[NSURL URLWithString:@"http://172.16.3.10/"]];
//    NSURL *url = [NSURL URLWithString:@"http://172.16.3.92/xuele1.html"];
    NSString *str = [[NSBundle mainBundle] pathForResource:@"index2" ofType:@"html"];
    NSURL *url = [NSURL URLWithString:str];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    printf("%s\n",__FUNCTION__);
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
//    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    context[@"app"] = self;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    printf("%s\n",__FUNCTION__);
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

- (void)webView:(UIWebView *)webView didCreateWithContext:(JSContext *)context{
    context[@"xueleapp"] = self;
}


#pragma mark - private
- (void)openLocal{

    printf("%s\n",__FUNCTION__);
}

- (NSString *)getOCToken{
    printf("%s\n",__FUNCTION__);
    return @"gulong";
}

- (NSString *)getToken{
    printf("%s\n",__FUNCTION__);
    return @"gulong";
}

- (void)ocSum:(NSInteger)a __JS_EXPORT_AS__sum:(id)argument{
    printf("%s\n",__FUNCTION__);
}

- (void)ocSum:(NSInteger)a :(NSInteger)b{
//    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    printf("%s\n",__FUNCTION__);
}

- (void)add:(NSInteger)a :(NSInteger)b{
    if (b == NSNotFound) {
        b = 0;
    }
    printf("%s=%ld\n",__FUNCTION__,a+b);
}

- (UIWebView *)webView{
    if (_webView == nil) {
        UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.bounds];
        web.delegate = self;
        web.allowsLinkPreview = YES;
        [self.view addSubview:web];
        _webView = web;
       
    }
    return _webView;
}

@end
