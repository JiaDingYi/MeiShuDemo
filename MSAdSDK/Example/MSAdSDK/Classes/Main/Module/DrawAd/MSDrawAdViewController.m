//
//  MSDrawAdViewController.m
//  MSAdSDKDev
//
//  Created by leej on 2022/2/18.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MSDrawAdViewController.h"
#import "MSDrawAdViewShowController.h"

@interface MSDrawAdViewController ()<MSDrawAdManagerDelegate,MSDrawAdExtensionFunctionDelegate>
@property(nonatomic,strong) UILabel *statusLabel;
@property(nonatomic,strong) UILabel *adInfoLabel;
@property(nonatomic,strong) UIButton *muteBtn;
@property(nonatomic,strong) UIButton *showBtn;
@property(nonatomic,strong) UIButton *loadBtn;
@property(nonatomic,strong) UITextField *defaultPidTF;
@property(nonatomic,strong) MSDrawAdManager *drawAd;
@property(nonatomic,strong) NSMutableArray *adData;
@property(nonatomic,strong) MSDrawAdViewShowController *showVC;
@end

@implementation MSDrawAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.adData = [[NSMutableArray alloc]init];
    self.statusLabel.text = @"";
    self.adType = MSAdTypeDraw;
    self.defaultPidTF = [MSQuickCreate defaultPidTextField];
    [self.view addSubview:self.defaultPidTF];
    [self setUpView];
    self.defaultPidTF.text = self.defaultPid;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.adData removeAllObjects];
    self.showBtn.enabled = NO;
    self.adInfoLabel.text = @"";
    self.statusLabel.text = @"";
}
- (void)loadAd:(UIButton *)sender {
    self.statusLabel.text = @"加载中";
    NSString *pid = self.defaultPidTF.text;
    MSDrawAdConfigParams *param = [[MSDrawAdConfigParams alloc]init];
    //指定广告尺寸
    param.adSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-88);
    [self.drawAd loadAdWithPid:pid count:1 adParams:param delegate:self];
}
#pragma mark MSDrawAdManagerDelegate
-(void)msDrawAdManagerLoadSuccess:(NSArray<MSDrawAd *> *)drawAds{
    [self.adData addObjectsFromArray:drawAds];
    NSMutableString *alertSring = [[NSMutableString alloc]init];
    for (int index=0; index<self.adData.count; index++) {
        MSDrawAd *draw = self.adData[index];
        NSDictionary *adInfoDict = [draw mediaExt];
        for (NSString *key in adInfoDict.allKeys) {
            [alertSring appendString:[NSString stringWithFormat:@"%@ = %@\n",key,[adInfoDict objectForKey:key]]];
        }
        [alertSring appendString:@"******广告信息******\n"];
        self.adInfoLabel.text = alertSring.copy;
        //此处模拟美数竞价成功或失败
        if ([draw.mediaExt[kMSAdMediaAdnPlatformKey]integerValue] != MSPlatformMS) {
            [self sendLossNotificationWithInfo:draw.mediaExt adLoader:draw];
        } else {
            [self sendWinNotificationWithInfo:draw.mediaExt adLoader:draw];
        }
    }
    self.statusLabel.text = @"广告加载成功";
    [self addDelegateString:[NSString stringWithFormat:@"广告加载成功%@",NSStringFromSelector(_cmd)]];
    self.showBtn.enabled = YES;
}
-(void)msDrawAdManagerLoadFailed:(NSError *)error{
    self.statusLabel.text = @"加载失败";
    NSString *err = error.localizedDescription;
    if (err.length>0) {
        self.statusLabel.text = err;
    }else{
        self.statusLabel.text = @"广告加载异常，稍后再试";
    }
    [self addDelegateString:[NSString stringWithFormat:@"广告展示失败,错误：%@%@",error.localizedDescription,NSStringFromSelector(_cmd)]];
}
-(void)msDrawAdManagerPlatformError:(MSPlatform)platform videoAd:(MSDrawAd *)drawAd error:(NSError *)error{
    [self addDelegateString:[NSString stringWithFormat:@"当前平台广告加载失败,错误：%@%@",error.localizedDescription,NSStringFromSelector(_cmd)]];
    [MSLogger logString:[NSString stringWithFormat:@"当前平台广告加载失败,错误：%@",error.localizedDescription] platform:platform];
}
-(void)msDrawAdVideoCacheSuccess:(MSDrawAd *)drawAd{
    self.statusLabel.text = @"缓存成功";
    [self addDelegateString:[NSString stringWithFormat:@"广告缓存成功%@",NSStringFromSelector(_cmd)]];
}
-(void)msDrawAdVideoCacheFailed:(MSDrawAd *)drawAd withError:(NSError *)error{
    self.statusLabel.hidden = NO;
    [self.view bringSubviewToFront:self.statusLabel];
    self.statusLabel.text = @"缓存失败";
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]缓存失败%@",drawAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
    [self.adData removeObject:drawAd];
    if (_showVC) {
        [_showVC reloadAdDataSource:self.adData.copy];
    }
}
#pragma mark -SetUpView
-(void)setUpView{
    self.statusLabel = [MSQuickCreate statusLabel];
    [self.view addSubview:self.statusLabel];
    [self.view addSubview:self.muteBtn];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.equalTo(self.defaultPidTF.mas_top).offset(-10);
    }];
    [self.defaultPidTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.bottom.equalTo(self.loadBtn.mas_top).offset(-20);
    }];
    [self.loadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.bottom.equalTo(self.muteBtn.mas_top).offset(-20);
    }];
    [self.muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.loadBtn);
        make.bottom.mas_equalTo(self.showBtn.mas_top).offset(-20);
    }];
    [self.adInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(88);
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.bottom.mas_equalTo(self.statusLabel.mas_top).offset(-20);
    }];
    [self.showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.loadBtn);
        make.bottom.mas_equalTo(self.view).offset(-60);
    }];
}
-(void)muteBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    sender.backgroundColor = sender.selected ? [UIColor greenColor] : [UIColor lightGrayColor];
}
-(void)showBtnClick:(UIButton *)sender{
    [self.navigationController pushViewController:self.showVC animated:NO];
    self.showVC.isMute = self.muteBtn.isSelected;
    [self.showVC reloadAdDataSource:self.adData.copy];
}
-(UILabel *)adInfoLabel{
    if (!_adInfoLabel) {
        _adInfoLabel = [MSQuickCreate statusLabel];
        [self.view addSubview:_adInfoLabel];
        _adInfoLabel.layer.borderColor = UIColor.blueColor.CGColor;
        _adInfoLabel.layer.borderWidth = 0.5;
        _adInfoLabel.textAlignment = NSTextAlignmentLeft;
        _adInfoLabel.font = [UIFont systemFontOfSize:13];
        _adInfoLabel.numberOfLines = 0;
        _adInfoLabel.textColor  = UIColor.blackColor;
    }
    return _adInfoLabel;
}
-(UIButton *)muteBtn{
    if (!_muteBtn) {
        _muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_muteBtn setTitle:@"未开启静音" forState:UIControlStateNormal];
        [_muteBtn setTitle:@"已开启静音" forState:UIControlStateSelected];
        [_muteBtn addTarget:self action:@selector(muteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _muteBtn.backgroundColor = [UIColor blueColor];
        _muteBtn.selected = YES;
    }
    return _muteBtn;
}
-(UIButton *)showBtn{
    if (!_showBtn) {
        _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showBtn setTitle:@"展示广告" forState:UIControlStateNormal];
        [_showBtn setTitle:@"无可用广告" forState:UIControlStateDisabled];
        [_showBtn addTarget:self action:@selector(showBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _showBtn.backgroundColor = [UIColor blueColor];
        _showBtn.enabled = NO;
        [self.view addSubview:_showBtn];
    }
    return _showBtn;
}
-(UIButton *)loadBtn{
    if (!_loadBtn) {
        _loadBtn = [MSQuickCreate longActionBtn];
        _loadBtn.backgroundColor = [UIColor blueColor];
        [_loadBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_loadBtn setTitle:@"加载广告" forState:UIControlStateNormal];
        [_loadBtn addTarget:self action:@selector(loadAd:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_loadBtn];
    }
    return _loadBtn;
}
-(MSDrawAdManager *)drawAd{
    if (!_drawAd) {
        _drawAd = [[MSDrawAdManager alloc]init];
    }
    return _drawAd;
}
-(MSDrawAdViewShowController *)showVC{
    if (!_showVC) {
        _showVC = [MSDrawAdViewShowController new];
        __weak typeof(self)weakSelf = self;
        _showVC.delegateBlock = ^(NSString * _Nonnull delegateInfo) {
            [weakSelf addDelegateString:delegateInfo];
        };
    }
    return _showVC;
}
-(void)dealloc{
    [MSLogger logString:[NSString stringWithFormat:@"%@-%@",NSStringFromClass(self.class),NSStringFromSelector(_cmd)] platform:-1];
}
@end
