//
//  UIWebView+JavaScript.m
//  JavaScriptDemo
//
//  Created by lexandera on 2018/9/11.
//  Copyright © 2018年 历山大亚. All rights reserved.
//

#import "UIWebView+JavaScript.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <objc/runtime.h>

static const char kJavaScriptContext[] = "xly_javaScriptContext";
static NSHashTable * xly_webViews = nil;


@implementation UIWebView (JavaScriptContext)

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xly_webViews = [NSHashTable weakObjectsHashTable];
    });
    NSAssert( [NSThread isMainThread], @"uh oh - why aren't we on the main thread?");
    
    id webView = [super allocWithZone:zone];
    [xly_webViews addObject:webView];
    return webView;
}

- (void)xly_didCreateJavaScriptContext:(JSContext *)context{
    [self willChangeValueForKey:@"javaScriptContext"];
    objc_setAssociatedObject(self, kJavaScriptContext, context, OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"javaScriptContext"];
    
    if ([self.delegate respondsToSelector:@selector(webView:didCreateWithContext:)]) {
        id<XLYWebViewDelegate> delegate = (id<XLYWebViewDelegate>)self.delegate;
        [delegate webView:self didCreateWithContext:context];
    }
    
}

- (JSContext *)javaScriptContext{
    JSContext * context = objc_getAssociatedObject(self, kJavaScriptContext);
    return context;
}

- (void)removeFromHashTable{
    [xly_webViews removeObject:self];
}

@end

@implementation NSObject (JavaScriptContext)

- (void)webView:(id)unused didCreateJavaScriptContext:(JSContext *)ctx forFrame:(id)frame{
    void(^notifyDidCreateJavaScriptContext)(void) = ^{
        for (UIWebView *webView in xly_webViews) {
            NSString * gl = [NSString stringWithFormat:@"xly_jscWebView_%lud",(unsigned long)webView.hash];
            //往js中注入一个变量
            [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"var %@ = '%@'",gl, gl]];
            if ([ctx[gl].toString isEqualToString:gl]) {
                [webView xly_didCreateJavaScriptContext:ctx];
            }
        }
    };
    if ([NSThread isMainThread]) {
        notifyDidCreateJavaScriptContext();
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            notifyDidCreateJavaScriptContext();
        });
    }
}

- (void)removeWebView:(UIWebView *)webView{
    if (webView) {
        [xly_webViews removeObject:webView];
    }
}

@end

