//
//  MSSplashSettingView.m
//  MSAdSDKDev
//
//  Created by lj on 2021/4/9.
//  Copyright © 2021 Adxdata. All rights reserved.
//

#import "MSSplashSettingView.h"

@interface MSSplashSettingView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UITableView *settingTableview;
@property(nonatomic,strong)UISwitch *showSkipViewBtn;
@property(nonatomic,strong)UISlider *bottomSlider;
@property(nonatomic,strong)UISwitch *showBtn;
@property(nonatomic,strong)UISwitch *openThirdBtn;
@property(nonatomic,strong)UISwitch *hideSkipBtn;
@property(nonatomic,strong)UISwitch *denyCatBtn;
@property(nonatomic,strong)UISwitch *denyCidBtn;
@property(nonatomic,strong)UISwitch *denyAderIdBtn;
@property(nonatomic,strong)UITextField *timeOutTF;
@end
@implementation MSSplashSettingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.settingTableview];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.settingTableview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 260);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    cell.detailTextLabel.text = self.dataArray[indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor blackColor];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    switch (indexPath.row) {
        case 0:
        {
            [cell.contentView addSubview:self.showBtn];
            break;
        }
        case 1:
        {
            [cell.contentView addSubview:self.openThirdBtn];
            break;
        }
        case 2:
        {
            [cell.contentView addSubview:self.showSkipViewBtn];
            break;
        }
        case 3:
        {
            [cell.contentView addSubview:self.bottomSlider];
            break;
        }
        case 4:
        {
            [cell.contentView addSubview:self.hideSkipBtn];
            break;
        }
        case 5:
        {
            [cell.contentView addSubview:self.denyCatBtn];
            break;
        }
        case 6:
        {
            [cell.contentView addSubview:self.denyCidBtn];
            break;
        }
        case 7:
        {
            [cell.contentView addSubview:self.denyAderIdBtn];
            break;
        }
        case 8:
        {
            [cell.contentView addSubview:self.timeOutTF];
            break;
        }
        default:
            break;
    }
    return cell;
}
-(void)slider:(UISlider *)slider{
    self.bottomHeight = ([UIScreen mainScreen].bounds.size.height*0.25)*self.bottomSlider.value;
    NSString *str = self.dataArray[3];
    str = [NSString stringWithFormat:@"当前bottomView高度：%.0f",self.bottomHeight];
    [self.dataArray replaceObjectAtIndex:3 withObject:str];
    UITableViewCell *cell = [self.settingTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    cell.detailTextLabel.text = str;
    if ([self.delegate respondsToSelector:@selector(adjustBottomViewHeight:)]) {
        [self.delegate adjustBottomViewHeight:self.bottomHeight];
    }
}
-(void)showSkipViewBtnClick{
    self.showSkipView = self.showSkipViewBtn.on;
    if ([self.delegate respondsToSelector:@selector(showSkipViewBtnClick:)]) {
        [self.delegate showSkipViewBtnClick:self.showSkipViewBtn.on];
    }
}
-(void)showBtnClick{
    self.loadAndShow = self.showBtn.on;
    if ([self.delegate respondsToSelector:@selector(loadAndShowSplash:)]) {
        [self.delegate loadAndShowSplash:self.showBtn.on];
    }
}
-(void)openThirdBtnClick{
    self.openThirdWords = self.openThirdBtn.on;
    if ([self.delegate respondsToSelector:@selector(openThirdBtnClick:)]) {
        [self.delegate openThirdBtnClick:self.openThirdBtn.on];
    }
}
-(void)hideSkipBtnClick{
    self.hideSkipView = self.hideSkipBtn.on;
    if ([self.delegate respondsToSelector:@selector(hideSkipBtnClick:)]) {
        [self.delegate hideSkipBtnClick:self.hideSkipBtn.on];
    }
}
-(void)denyCatBtnBtnClick{
    self.denyCat = self.denyCatBtn.on;
}
-(void)denyCidBtnBtnClick{
    self.denyCid = self.denyCidBtn.on;
}
-(void)denyAderIdBtnBtnClick{
    self.denyAderId = self.denyAderIdBtn.on;
}
-(NSInteger)timeOut{
    return [self.timeOutTF.text integerValue];
}
-(UITableView *)settingTableview{
    if (!_settingTableview) {
        _settingTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 260) style:UITableViewStylePlain];
        _settingTableview.delegate = self;
        _settingTableview.dataSource = self;
        _settingTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _settingTableview.separatorColor = [UIColor lightGrayColor];
        _settingTableview.tableFooterView=[[UIView alloc]init];
        _settingTableview.backgroundColor=[UIColor blackColor];
        _settingTableview.alpha = 0.95;
        [self addSubview:_settingTableview];
    }
    return _settingTableview;
}
-(UISwitch *)showSkipViewBtn{
    if (!_showSkipViewBtn) {
        _showSkipViewBtn = [[UISwitch alloc]initWithFrame:CGRectMake(20, 10, 44, 44)];
        [_showSkipViewBtn addTarget:self action:@selector(showSkipViewBtnClick) forControlEvents:UIControlEventValueChanged];
    }
    return _showSkipViewBtn;
}
-(UISwitch *)showBtn{
    if (!_showBtn) {
        _showBtn = [[UISwitch alloc]initWithFrame:CGRectMake(20, 10, 44, 44)];
        [_showBtn addTarget:self action:@selector(showBtnClick) forControlEvents:UIControlEventValueChanged];
    }
    return _showBtn;
}
-(UISwitch *)openThirdBtn{
    if (!_openThirdBtn) {
        _openThirdBtn = [[UISwitch alloc]initWithFrame:CGRectMake(20, 10, 44, 44)];
        [_openThirdBtn addTarget:self action:@selector(openThirdBtnClick) forControlEvents:UIControlEventValueChanged];
    }
    return _openThirdBtn;
}
-(UISwitch *)hideSkipBtn{
    if (!_hideSkipBtn) {
        _hideSkipBtn = [[UISwitch alloc]initWithFrame:CGRectMake(20, 10, 44, 44)];
        [_hideSkipBtn addTarget:self action:@selector(hideSkipBtnClick) forControlEvents:UIControlEventValueChanged];
    }
    return _hideSkipBtn;
}
-(UISwitch *)denyCatBtn{
    if (!_denyCatBtn) {
        _denyCatBtn = [[UISwitch alloc]initWithFrame:CGRectMake(20, 10, 44, 44)];
        [_denyCatBtn addTarget:self action:@selector(denyCatBtnBtnClick) forControlEvents:UIControlEventValueChanged];
    }
    return _denyCatBtn;
}
-(UISwitch *)denyCidBtn{
    if (!_denyCidBtn) {
        _denyCidBtn = [[UISwitch alloc]initWithFrame:CGRectMake(20, 10, 44, 44)];
        [_denyCidBtn addTarget:self action:@selector(denyCidBtnBtnClick) forControlEvents:UIControlEventValueChanged];
    }
    return _denyCidBtn;
}
-(UISwitch *)denyAderIdBtn{
    if (!_denyAderIdBtn) {
        _denyAderIdBtn = [[UISwitch alloc]initWithFrame:CGRectMake(20, 10, 44, 44)];
        [_denyAderIdBtn addTarget:self action:@selector(denyAderIdBtnBtnClick) forControlEvents:UIControlEventValueChanged];
    }
    return _denyAderIdBtn;
}
-(UISlider *)bottomSlider{
    if (!_bottomSlider) {
        _bottomSlider = [[UISlider alloc]initWithFrame:CGRectMake(20, 0, 160, 40)];
        [_bottomSlider addTarget:self action:@selector(slider:) forControlEvents:UIControlEventValueChanged];
    }
    return _bottomSlider;
}
-(UITextField *)timeOutTF{
    if (!_timeOutTF) {
        _timeOutTF = [MSQuickCreate defaultPidTextField];
        _timeOutTF.keyboardType = UIKeyboardTypeNumberPad;
        _timeOutTF.placeholder = @"单位：秒";
        _timeOutTF.frame = CGRectMake(20, 10, 100, 20);
        _timeOutTF.font = [UIFont systemFontOfSize:12];
    }
    return _timeOutTF;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]initWithArray:@[
            @"开启即时展示",
            @"展示进入第三方页面按钮（支持MS、百度）",
            @"展示自定义跳过按钮(仅支持MS、广点通)",
            @"当前bottomView高度：0",
            @"隐藏跳过按钮（支持MS、穿山甲）",
            @"屏蔽行业ID(支持MS)",
            @"屏蔽创意ID(支持MS)",
            @"屏蔽广告主ID(支持MS)",
            @"超时时长"
        ]];
    }
    return _dataArray;
}
@end
