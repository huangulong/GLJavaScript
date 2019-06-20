//该文件 只是为了分享文档 非编译文件


题外话
1. 内存机制
     oc 语言是支持内存回收机制的，但是ios不支持
     MRC 手动管理内存 引用计数为0时 内存被摧毁。 retain +1 release -1
     ARC 自动管理内存 特点是自动引用技术简化了内存管理的难度，xcode编译器帮你做了 retain和release操作
     在ARC里，如果两个对象互相强引用 将导致它们永远不会被释放

2. 语法...
     //if for while do-while
     //封装 多态 继承
     //异常处理 [array objectAtIndex:i];

3. 沙盒
    //app main bundle
    //沙盒 bundle







--- oc 和 js 交互
1. 运行
    一个webView虚拟引擎   JSVirtualMachine
    一个Html一个上下文对象 JSContext

xueleapp://mesagee?mmmm='url'
2. 重定向(url 拦截)
  2.1 js 调用 oc方法
   在发送url oc会有代理检查请求的合理性
    - (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
        printf("%s\n",__FUNCTION__);
        if ([url.scheme isEqualToString:@"ios"]) {
            //        url.path  然后使用 path的数据来处理相应的东西
            //        return NO;   //要处理事件 此处就必须拦截啦
            return NO;
        }
        return YES;
    }

    html <a href="xueleApp://message/chat?type=PR&tId=1000110002">xx的消息</a>
    js   window.location.href = "xueleApp://message/chat?type=PR&tId=1000110002"

  2.2 oc 调用 js 方法
    [self.webView stringByEvaluatingJavaScriptFromString:@"function(1,2);"];

  2.2 使用oc方法向js中注册方法调用oc的方法
    NSString * js = @"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ocmethod(){" //添加函数 到‘}’结束
    "window.location.href = 'xueleapp://message?mid=2222222';"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    //写入js方法
    [self.webView stringByEvaluatingJavaScriptFromString:js];


3. JavaScriptCore(UIWebView UIKit) ios7.0可用

   3.1 js 调用 oc
     3.1.1 写入一个类 继承JSExport
     3.1.2 在合适的时间点注册给 JSContext对象(键值对 可注册多个继承自JSExport的自定义类)
        context["xueleapp"] = exportObject;
        //exportObject 被强引用了
     3.1.3 js的调用和oc的方法对应即可
        eg. js 调用 window.xueleapp.openNewPage('m',true)
            oc -(void)openNewPage:(NSString *)page :(Bool)flag;

   3.2 oc 调用 js
      [context evaluateScript:@"function(1,2)"];

   3.3 合适时间的找寻
     3.3.1 html加载前
     3.3.2 html加载后
     3.3.3 js上下文生成后

4. WKScriptMessageHandler(WKWebView WebKit) ios8.0 可用
   与Safari相同的JavaScript引擎
   4.1 将方法注册到js中
[self.webView.configuration.userContentController addScriptMessageHandler:self name:@"closePage"];


   4.2 代理回调
- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message;

   4.3 js 调用 oc
    window.webkit.messageHandlers.pickFile.postMessage(2);


   4.4 oc 调用js
    [self.webView evaluateJavaScript:complete:]
5. 第三方  基本靠URL拦截的方式写的
   5.1 WebViewJavascriptBridge
   5.2 cordova库(PhoneGap)
   5.3 React Native














6. webView 的图层结构
UIWebView
- _UIWebViewScrollView  //保证其缩放 滚动
- UIWebBrowserView    //渲染

WKWebView
- WKScrollView    //保证其缩放 滚动
- WKContentView  //渲染 最终的渲染在其子视图上面
| ....          //中间还有很多层UIView 和 WKCompositingView
- WKCompositingView
