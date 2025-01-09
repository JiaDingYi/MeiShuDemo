//
//  MSInterstitialViewController.m
//  MSAdSDKDev
//
//  Created by Liumaos on 2020/7/23.
//  Copyright © 2020 Adxdata. All rights reserved.
//

#import "MSInterstitialViewController.h"

@interface MSInterstitialViewController ()<MSInterstitialDelegate,MSInterstitialExtensionFunctionDelegate>
@property(nonatomic,strong) UILabel *statusLabel;
@property(nonatomic,strong) UIButton *playBtn;
@property(nonatomic,strong) UIButton *muteBtn;
@property(nonatomic,strong) UITextField *defaultPidTF;
@property(nonatomic,strong) UIButton *openAutoCloseBtn;
@property(nonatomic,strong) MSInterstitialAd *interstitialAd;
@end

@implementation MSInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playBtn.enabled = NO;
    self.defaultPidTF.text = self.defaultPid;
    self.statusLabel.text = @"";
    self.adType = MSAdTypeInterstitial;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)loadAd:(UIButton *)sender {
    NSString *pid = @"1061835";
    self.playBtn.enabled = NO;
    self.statusLabel.text = @"加载中";
    MSInterstitialAdConfigParams *adParam = [[MSInterstitialAdConfigParams alloc]init];
    adParam.videoMuted = self.muteBtn.selected;
    adParam.isNeedCloseAdAfterClick = self.openAutoCloseBtn.selected;
    self.interstitialAd = [[MSInterstitialAd alloc]init];
    self.interstitialAd.delegate = self;
    self.interstitialAd.extDelegate = self;
    [self.interstitialAd loadAdWithPid:pid adConfigParams:adParam];
}
- (void)showAd:(UIButton *)sender {
    [self.interstitialAd showAdFromRootViewController:self];
}
#pragma mark- Delegate
- (void)msInterstitialError:(MSInterstitialAd *)msInterstitialAd
                      error:(NSError *)error{
    NSString *err = error.localizedDescription;
    if (err.length>0) {
        self.statusLabel.text = err;
    }else{
        self.statusLabel.text = @"广告加载异常，稍后再试";
    }
    [self addDelegateString:[NSString stringWithFormat:@"插页广告展示失败,错误：%@%@",error.localizedDescription,NSStringFromSelector(_cmd)]];
}
- (void)msInterstitialShow:(MSInterstitialAd *)msInterstitialAd{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]插页广告展示成功%@",self.interstitialAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
- (void)msInterstitialClosed:(MSInterstitialAd *)msInterstitialAd{
    self.playBtn.enabled = NO;
    self.statusLabel.text = @"";
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]插页广告已关闭%@",self.interstitialAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
- (void)msInterstitialClicked:(MSInterstitialAd *)msInterstitialAd{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]插页广告被点击%@",self.interstitialAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
- (void)msInterstitialDetailClosed:(MSInterstitialAd *)msInterstitialAd{
    self.statusLabel.text = @"";
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]插页广告详情页已关闭%@",self.interstitialAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msInterstitialAdReadySuccess:(MSInterstitialAd *)msInterstitialAd{
    self.playBtn.enabled = YES;
    self.statusLabel.text = @"已加载";
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]插页广告展示就绪%@",self.interstitialAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msInterstitialAdShowFail:(MSInterstitialAd *)msInterstitialAd error:(NSError *)error{
    self.statusLabel.text = @"插页广告展示失败";
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]插页广告展示失败%@",self.interstitialAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
#pragma mark MSInterstitialExtensionFunctionDelegate
- (void)msInterstitialLoaded:(MSInterstitialAd *)msInterstitialAd{
    //此处模拟美数竞价成功或失败
    if ([msInterstitialAd.mediaExt[kMSAdMediaAdnPlatformKey]integerValue] != MSPlatformMS) {
        [self sendLossNotificationWithInfo:msInterstitialAd.mediaExt adLoader:msInterstitialAd];
    } else {
        [self sendWinNotificationWithInfo:msInterstitialAd.mediaExt adLoader:msInterstitialAd];
    }
    [self showAlert:msInterstitialAd.mediaExt];
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]插页广告加载成功%@",self.interstitialAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msInterstitialPlatformError:(MSPlatform)platform
                                ad:(MSInterstitialAd *)msInterstitialAd
                             error:(NSError *)error{
    [self addDelegateString:[NSString stringWithFormat:@"当前平台插页广告展示失败,错误：%@%@",error.localizedDescription,NSStringFromSelector(_cmd)]];
}
#pragma mark -SetUpView
-(void)setUpView{
    self.defaultPidTF = [MSQuickCreate defaultPidTextField];
    [self.view addSubview:self.defaultPidTF];
    UIButton * loadBtn = [MSQuickCreate longActionBtn];
    [loadBtn setTitle:@"加载广告" forState:UIControlStateNormal];
    [loadBtn addTarget:self
                action:@selector(loadAd:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadBtn];
    UIButton * playBtn = [MSQuickCreate longActionBtn];
    [playBtn setTitle:@"展示广告" forState:UIControlStateNormal];
    [playBtn addTarget:self
              action:@selector(showAd:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    self.playBtn = playBtn;
    self.statusLabel = [MSQuickCreate statusLabel];
    [self.view addSubview:self.statusLabel];
    [self.view addSubview:self.muteBtn];
    [self.view addSubview:self.openAutoCloseBtn];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.equalTo(self.defaultPidTF.mas_top).offset(-10);
    }];
    [self.defaultPidTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
    }];
    [loadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.top.equalTo(self.defaultPidTF.mas_bottom).offset(20);
    }];
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.bottom.equalTo(self.muteBtn.mas_top).offset(-20);
        make.top.equalTo(loadBtn.mas_bottom).offset(20);
    }];
    [self.muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(playBtn);
        make.bottom.mas_equalTo(self.view).offset(-60);
    }];
    [self.openAutoCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.muteBtn.mas_right).offset(5);
        make.height.bottom.mas_equalTo(self.muteBtn);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
    }];
}
-(void)muteBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
}
- (void)openAutoCloseBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
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
-(UIButton *)openAutoCloseBtn{
    if (!_openAutoCloseBtn) {
        _openAutoCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openAutoCloseBtn setTitle:@"未开启自动关闭广告" forState:UIControlStateNormal];
        [_openAutoCloseBtn setTitle:@"已开启自动关闭广告" forState:UIControlStateSelected];
        [_openAutoCloseBtn addTarget:self action:@selector(openAutoCloseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _openAutoCloseBtn.backgroundColor = [UIColor blueColor];
    }
    return _openAutoCloseBtn;
}
-(void)dealloc{
    [MSLogger logString:[NSString stringWithFormat:@"%@-%@",NSStringFromClass(self.class),NSStringFromSelector(_cmd)] platform:-1];
}
@end
