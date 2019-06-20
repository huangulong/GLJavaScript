//
//  GLWebViewController.m
//  JavaScriptDemo
//
//  Created by lexandera on 2018/9/30.
//  Copyright © 2018年 历山大亚. All rights reserved.
//

#import "GLWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface GLWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) JSContext * globaContext;

@property (nonatomic, strong) UIWebView * webView;

@end

@implementation GLWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"JSContext";
    JSContext *context = [[JSContext alloc] init];
    NSLog(@"%@",context);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"right" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightClick:)];
    [self loadRequest];
}

- (void)loadRequest{
    NSURL *url = [NSURL URLWithString:@"index2.html" relativeToURL:[NSURL URLWithString:@"http://localhost/"]];
    //    NSURL *url = [NSURL URLWithString:@"http://172.16.3.92/xuele1.html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}


#pragma mark - event
- (IBAction)rightClick:(id)sender{

    [self test4];
    
}

//引入外部的js方法
- (void)test7 {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"js"];
    NSString *testScript = [NSString stringWithContentsOfFile:path encoding:(NSUTF8StringEncoding) error:NULL];
    
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [context evaluateScript:testScript];
    JSValue *function = context[@"factorial"];
    JSValue *result = [function callWithArguments:@[@3]];
    NSLog(@"factorial(10) = %d",[result toInt32]);
}

//异常处理 好像只能处理evaluateScript 产生的异常，无法获取html5产生的异常
- (void)test6 {
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"exp = %@",exception);
    };
    [context evaluateScript:@"ideal.zheng = 21;"];
}

//使用JSContext 添加函数以及函数的调用 2
- (void)test5 {
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //生成一个函数log 让html页面自己调用
//    <div id="hgl4" onclick="log(2,['h','g']);">oc local log</div>
    [context evaluateScript:@"function log(a,b){"
     "alert(a);}"];
    
    //生成一个函数log ，oc自己调用
    //evaluateScript  该方法不仅能获取变量还能获取函数指针，更能执行语句
    [context evaluateScript:@"function add(a,b){return a+b;}"];
    JSValue *sum1 = [context evaluateScript:@"add(2,3);"];
    JSValue *add = [context evaluateScript:@"add"]; //context[@"add"];
    JSValue *sum2 = [add callWithArguments:@[@(21),@(23)]];
    NSLog(@"sum1 = %d",sum1.toInt32);
    NSLog(@"sum2 = %d",sum2.toInt32);
                     
    
}

//使用JSContext 添加函数 1
//block
//1.不要在 Block 中直接使用外面的 JSValue 对象
//2.避免循引用，不要在 Block 中直接引用使用外面的 JSContext 对象，应该用[JSContext currentContext];
- (void)test4 {
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"xueleapp"][@"log"] = ^(){
        NSLog(@"++++++++++++Begin Log+++++++++++++");
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"%@",jsVal);
        }
        //当在
        JSValue *this1 = [JSContext currentThis];
        NSLog(@"this :%@",this1);
        NSLog(@"------------End Log-----------");
    };
    context[@"xueleapp"][@"log"];
    //本地调用log
    [context evaluateScript:@"xueleapp.log('ideal',[7,22],{hello:'world',js:100});"];
//    也可在html中写调用
//    <div id="hgl4" onclick="log(2,['h','g']);">oc local log</div>
}

- (void)test3 {
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //为js 生成变量并赋值
    [context evaluateScript:@"var arr = [21,7,'huang'];"];
    
    //调用 js sdk中的方法
    JSValue *m1 = [context evaluateScript:@"'huang'.toUpperCase();"];
    NSLog(@"m1 = %@",m1.toString);
    //调用 js 自定义的变量
    JSValue *m2 = [context evaluateScript:@"document.title"];
    NSLog(@"m2 = %@",m2.toString);
    
    JSValue *m3 = [context evaluateScript:@"arr"];
    NSLog(@"JS Array : %@;Length : %@",m3,m3[@"length"]);
    m3[1] = @"blog";//改变m3 的值，js 中的arr变量也会同步改变
    m3[7] = @(5);//越界插入数值 中间值会以NULL占据
    NSLog(@"JS Array : %@;Length : %@",m3,m3[@"length"]);
    
}

//2.使用webview的js context 调用方法
- (void)test2 {
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    JSValue *value = [context evaluateScript:@"jump();"];
    NSLog(@"%@",value);
}

//1.使用webview 直接调用js
- (void)test1 {
    //jump 是 html head定义的方法，调用‘window.jump();’ 成功，调用‘jump();’ 成功
    NSString *str = [self.webView stringByEvaluatingJavaScriptFromString:@"jump();"];
    NSLog(@"str = %@",str);
    return;
    
    //show 是 html body定义的方法，调用‘window.show();’ 成功，调用‘show();’ 成功
    NSString *str2 = [self.webView stringByEvaluatingJavaScriptFromString:@"window.show();"];
    NSLog(@"f = %@",str2);
    
}

//帮忙实现 js 的方法
- (void)test0 {
    NSString * js = @"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function closePage(){" //添加函数 到‘}’结束
    "document.location.href='ios://open'"
    "document.getElementById('hgl2').innerHTML= 'oc closePage  方法被调用';"
    "}"
    "var arr = [1,21,'gulong'];\";" //该方法是加入全局变量
    "document.getElementsByTagName('head')[0].appendChild(script);";
    
    //写入js方法
    [self.webView stringByEvaluatingJavaScriptFromString:@"mm('filekey')"];
    //必须主线程中调用 ，如果js执行事件过长，会导致卡屏
//    [self.webView stringByEvaluatingJavaScriptFromString:@"closePage()"];
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL * url = request.URL;
    if ([url.scheme isEqualToString:@"ios"]) {
//        url.path  然后使用 path的数据来处理相应的东西
//        return NO;   //要处理事件 此处就必须拦截啦
        
        UIAlertController * vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"你想要我干嘛！！" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *a = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [vc addAction:a];
        [self presentViewController:vc animated:YES completion:nil];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = title;
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
