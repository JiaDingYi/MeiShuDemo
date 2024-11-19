//
//  MSDelegateViewController.m
//  MSAdSDKDev
//
//  Created by lj on 2021/4/22.
//  Copyright © 2021 Adxdata. All rights reserved.
//

#import "MSDelegateViewController.h"
#import "MSTools.h"

@interface MSDelegateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation MSDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataSource[indexPath.row];
    return [MSTools getTextSize:[dict objectForKey:@"delegate"] fontSize:15 maxChatWidth:tableView.bounds.size.width-40].height+40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    NSDictionary *dict = self.dataSource[indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"delegate"];
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = [dict objectForKey:@"time"];
    BOOL isSelected = [[dict objectForKey:@"selected"]boolValue];
    if (isSelected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource=self;
        _tableView.delegate=self;
    }
    return _tableView;
}
@end
