//
//  ViewController.m
//  JavaScriptDemo
//
//  Created by lexandera on 2018/9/10.
//  Copyright © 2018年 历山大亚. All rights reserved.
//

#import "ViewController.h"
#import "GLWebViewController1.h"
#import "GLWebViewController.h"
#import "GLWebViewController2.h"
#import "GLWebViewController3.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView * tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"JavaScript";
    self.tableView.backgroundColor = [UIColor whiteColor];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [@[@"JSContext",@"UIWebView",@"WKWebView",@"重定向"] objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        GLWebViewController *vc = [[GLWebViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        GLWebViewController1 *vc = [[GLWebViewController1 alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        GLWebViewController2 *vc = [[GLWebViewController2 alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 3){
        GLWebViewController3 *vc = [[GLWebViewController3 alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (IBAction)rightClick:(id)sender{
    
}


- (UITableView *)tableView{
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

@end
