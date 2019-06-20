//
//  UIViewController+Alert.m
//  JavaScriptDemo
//
//  Created by lexandera on 2018/10/16.
//  Copyright © 2018年 历山大亚. All rights reserved.
//

#import "UIViewController+Alert.h"

@implementation UIViewController (Alert)

- (void)showMessage:(NSString *)message{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [vc addAction:action];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
