//
//  MSDeepLinkViewController.m
//  MSAdSDKDev
//
//  Created by lj on 2020/11/6.
//  Copyright © 2020 Adxdata. All rights reserved.
//

#import "MSDeepLinkViewController.h"

@interface MSDeepLinkViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation MSDeepLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Deeplink检测";
    [self.tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    NSDictionary *dict = self.dataSource[indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"title"];
    NSString *link = [dict objectForKey:@"name"];
    cell.detailTextLabel.text = @"前往app";
    cell.accessoryType = [[UIApplication sharedApplication ] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://",link]]]?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryDetailButton;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataSource[indexPath.row];
    NSURL *link =[NSURL URLWithString:[NSString stringWithFormat:@"%@://",[dict objectForKey:@"name"]]];
    if ([[UIApplication sharedApplication] canOpenURL:link]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:link options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    [self showView:@"成功唤起app"];
                }else{
                    [self showView:@"唤起app失败，本机未安装该应用，或者未配置白名单"];
                }
            }];
        } else {
            if ([[UIApplication sharedApplication] openURL:link]) {
                [self showView:@"成功唤起app"];
            }else{
                [self showView:@"唤起app失败，本机未安装该应用，或者未配置白名单"];
            }
        }
    }else{
        [self showView:@"唤起app失败，本机未安装该应用，或者未配置白名单"];
    }
}
-(void)showView:(NSString *)str{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"尝试唤起app" message:str preferredStyle:UIAlertControllerStyleAlert];
    [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
-(NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[
        ];
    }
    return _dataSource;
}

@end
