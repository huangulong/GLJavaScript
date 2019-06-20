//
//  UIWebView+JavaScript.h
//  JavaScriptDemo
//
//  Created by lexandera on 2018/9/11.
//  Copyright © 2018年 历山大亚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol XLYWebViewDelegate<UIWebViewDelegate>

@optional
- (void)webView:(UIWebView *)webView didCreateWithContext:(JSContext *)context;

@end

@interface UIWebView (JavaScriptContext)

@property (nonatomic, readonly) JSContext* javaScriptContext;

- (void)removeFromHashTable;

@end
