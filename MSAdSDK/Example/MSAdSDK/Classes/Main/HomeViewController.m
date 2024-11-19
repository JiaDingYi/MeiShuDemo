//
//  MSViewController.m
//  MSAdSDKDev
//
//  Created by Liumaos on 2020/7/15.
//  Copyright © 2020 XiXiHaha. All rights reserved.
//

#import "HomeViewController.h"
#import "MSModuleViewController.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,MSSplashAdDelegate>
@property(nonatomic,strong) MSSplashAd  *splash;
@property(nonatomic,strong) UITableView *tableview;
@property(nonatomic,strong) UIView      *headerView;
@property(nonatomic,strong) NSArray     *dataArray;
@property(nonatomic,strong) UITableView *settingTableview;
@property(nonatomic,strong) NSArray     *settingArray;
@property(nonatomic,assign) BOOL        isOpen;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MSSDK";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadAd];
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setTitle:@"工具" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightButton;
}
-(void)rightBtnClick{
    self.isOpen = !self.isOpen;
    if (self.isOpen) {
        [self.settingTableview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(self.view);
            make.width.mas_equalTo(180);
            make.top.mas_equalTo(self.view).offset(isMSIPhoneXSeries()?88:64);
        }];
        [UIView animateWithDuration:0.2 animations:^{
            self.tableview.alpha = 0.5;
            [self.view layoutIfNeeded];
        }];
        self.tableview.userInteractionEnabled=NO;
    }else{
        [self.settingTableview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(self.view);
            make.width.mas_equalTo(0);
            make.top.mas_equalTo(self.view).offset(isMSIPhoneXSeries()?88:64);
        }];
        [UIView animateWithDuration:0.2 animations:^{
            self.tableview.alpha = 1;
            [self.view layoutIfNeeded];
        }];
        self.tableview.userInteractionEnabled=YES;
    }
}
-(void)loadAd{
    self.splash = [[MSSplashAd alloc]init];
    self.splash.delegate = self;
    NSString *pid = [IdProviderFactory getPidFor:MSPlatformNameMS adType:MSAdTypeSplash];
    MSSplashAdConfigParams *adParam = [[MSSplashAdConfigParams alloc]init];
    adParam.adSize = self.view.bounds.size;
    adParam.hideSplashStatusBar = YES;
    [self.splash loadAndShowSplashAdWithPid:pid adParam:adParam inWindow:[UIApplication sharedApplication].keyWindow];
}
- (void)msSplashClosed:(MSSplashAd *)splashAd{
    [self.view addSubview:self.tableview];
    [self.tableview reloadData];
}
-(void)msSplashError:(MSSplashAd *)splashAd withError:(NSError *)error{
    [self.view addSubview:self.tableview];
    [self.tableview reloadData];
}
-(void)msSplashAdShowFail:(MSSplashAd *)splashAd error:(NSError *)error{
    [self msSplashError:splashAd withError:error];
}
#pragma mark-
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 0) {
        return self.dataArray.count;
    }else{
        return self.settingArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 0) {
        return 70;
    }else{
        return 44;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        }
        NSDictionary *dict = self.dataArray[indexPath.row];
        cell.textLabel.text = dict[@"title"];
        cell.detailTextLabel.text = dict[@"version"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewSettingCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewSettingCell"];
        }
        NSDictionary *dict = self.settingArray[indexPath.row];
        cell.textLabel.text = dict[@"title"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor lightGrayColor];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 0) {
        NSDictionary *dict = self.dataArray[indexPath.row];
        NSString *vcStr = dict[@"vc"];
        Class cls =  NSClassFromString(vcStr);
        MSModuleViewController *vc =  [[cls alloc]init];
        vc.platformName            =  dict[@"platform"];
        vc.title                   = dict[@"title"];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSDictionary *dict = self.settingArray[indexPath.row];
        NSString *vcStr = dict[@"destVC"];
        Class cls =  NSClassFromString(vcStr);
        MSDeepLinkViewController *dpVC = [[cls alloc]init];
        [self.navigationController pushViewController:dpVC animated:YES];
        [self rightBtnClick];
    }
}
-(UITableView *)tableview{
    if (!_tableview) {
        CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 0);
        _tableview = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView=[[UIView alloc]init];
        _tableview.tag = 0;
    }
    return _tableview;
}
-(UITableView *)settingTableview{
    if (!_settingTableview) {
        CGRect frame = CGRectMake(self.view.bounds.size.width, isMSIPhoneXSeries()?88:64, 0, self.view.bounds.size.height-(isMSIPhoneXSeries()?88:64));
        _settingTableview = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _settingTableview.delegate = self;
        _settingTableview.dataSource = self;
        _settingTableview.tableFooterView=[[UIView alloc]init];
        _settingTableview.tag = 1;
        _settingTableview.backgroundColor=[UIColor lightGrayColor];
        [self.view addSubview:_settingTableview];
    }
    return _settingTableview;
}

-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[
            @{
                @"title":@"MS",
                @"version":[MSAdSDK platformVersion:MSPlatformMS]?:@"未安装",
                @"vc":@"MSViewController",
                @"platform":MSPlatformNameMS
            },
            @{
                @"title":@"广点通",
                @"version":[MSAdSDK platformVersion:MSPlatformGDT]?:@"未安装",
                @"vc":@"GDTViewController",
                @"platform":MSPlatformNameGDT
            },
            @{
                @"title":@"穿山甲",
                @"version":[MSAdSDK platformVersion:MSPlatformBU]?:@"未安装",
                @"vc":@"BUViewController",
                @"platform":MSPlatformNameBU
            },
            @{
                @"title":@"百度",
                @"version":[MSAdSDK platformVersion:MSPlatformBD]?:@"未安装",
                @"vc":@"BDViewController",
                @"platform":MSPlatformNameBD
            },
            @{
                @"title":@"京东",
                @"version":[MSAdSDK platformVersion:MSPlatformJD]?:@"未安装",
                @"vc":@"JDViewController",
                @"platform":MSPlatformNameJD
            },
            @{
                @"title":@"快手",
                @"version":[MSAdSDK platformVersion:MSPlatformKS]?:@"未安装",
                @"vc":@"KSViewController",
                @"platform":MSPlatformNameKS
            },
            @{
                @"title":@"AdMob",
                @"version":@"",
                @"vc":@"AdMobViewController",
                @"platform":MSPlatformNameADMOB
            },
            @{
                @"title":@"自定义广告平台",
                @"version":@"",
                @"vc":@"MSCPViewController",
                @"platform":MSPlatformNameCP
            }
        ];
    }
    return _dataArray;
}
-(NSArray *)settingArray{
    if (!_settingArray) {
        _settingArray = @[
            @{
                @"title" : @"Deeplink检测",
                @"destVC" : @"MSDeepLinkViewController"
            }];
    }
    return _settingArray;
}

@end
