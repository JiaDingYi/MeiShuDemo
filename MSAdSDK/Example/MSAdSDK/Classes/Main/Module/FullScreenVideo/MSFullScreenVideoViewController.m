//
//  MSFullScreenVideoViewController.m
//  MSAdSDKDev
//
//  Created by leej on 2022/2/15.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MSFullScreenVideoViewController.h"

@interface MSFullScreenVideoViewController ()<MSExpressFullScreenVideoAdDelegate,MSExpressFullScreenVideoAdExtensionFunctionDelegate>
@property(nonatomic,strong) UITextField *defaultPidTF;
@property(nonatomic,strong) UILabel *statusLabel;
@property(nonatomic,strong) UIButton *playBtn;
@property(nonatomic,strong) UIButton *muteBtn;
@property(nonatomic,strong) MSExpressFullScreenVideoAd *videoAd;
@end

@implementation MSFullScreenVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playBtn.enabled = NO;
    self.statusLabel.text = @"";
    self.adType = MSAdTypeFullScreenVideo;
    [self setUpView];
    self.defaultPidTF.text = self.defaultPid;
}
- (void)loadAd:(UIButton *)sender {
    self.playBtn.enabled = NO;
    self.statusLabel.text = @"加载中";
    NSString *pid = self.defaultPidTF.text.length ? self.defaultPidTF.text : self.defaultPid;
    self.videoAd = [[MSExpressFullScreenVideoAd alloc]init];
    self.videoAd.delegate = self;
    self.videoAd.extDelegate = self;
    MSExpressFullScreenVideoAdConfigParams *param = [[MSExpressFullScreenVideoAdConfigParams alloc]init];
    param.videoMuted = self.muteBtn.selected;
    [self.videoAd loadAdWithPid:pid adConfigParams:param];
}
- (void)showAd:(UIButton *)sender {
    [self.videoAd showAdFromRootViewController:self];
}
#pragma mark delegate
-(void)msExpressFullScreenVideoAdDidStarted:(MSExpressFullScreenVideoAd *)video{
    self.statusLabel.text = @"开始播放";
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]开始播放%@",self.videoAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msExpressFullScreenVideoAdLoadSuccess:(MSExpressFullScreenVideoAd *)video{
    self.statusLabel.text = @"加载成功";
    [self showAlert:video.mediaExt];
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]加载成功%@",self.videoAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
    //此处模拟美数竞价成功或失败
    if ([video.mediaExt[kMSAdMediaAdnPlatformKey]integerValue] != MSPlatformMS) {
        [self sendLossNotificationWithInfo:video.mediaExt adLoader:video];
    } else {
        [self sendWinNotificationWithInfo:video.mediaExt adLoader:video];
    }
}
-(void)msExpressFullScreenVideoAdLoadFail:(MSExpressFullScreenVideoAd *)video error:(NSError *)error{
    self.statusLabel.text = @"加载失败";
    NSString *err = error.localizedDescription;
    if (err.length>0) {
        self.statusLabel.text = err;
    }else{
        self.statusLabel.text = @"广告加载异常，稍后再试";
    }
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]展示失败,错误：%@%@",self.videoAd.mediaExt[kMSAdMediaAdnNameKey],error.localizedDescription,NSStringFromSelector(_cmd)]];
}
-(void)msExpressFullScreenVideoAdReadySuccess:(MSExpressFullScreenVideoAd *)video{
    if (self.videoAd.isReady) {
        self.statusLabel.text = @"准备就绪";
        self.playBtn.enabled = YES;
        [self addDelegateString:[NSString stringWithFormat:@"[%@广告]展示就绪%@",self.videoAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
    }else{
        self.statusLabel.text = @"当前广告不可用";
        self.playBtn.enabled = NO;
        [self addDelegateString:[NSString stringWithFormat:@"[%@广告]不可用%@",self.videoAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
    }
}
-(void)msExpressFullScreenVideoAdReadyFailed:(MSExpressFullScreenVideoAd *)video withError:(NSError *)error{
    self.statusLabel.text = @"当前广告不可用";
    self.playBtn.enabled = NO;
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]不可用%@",self.videoAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msExpressFullScreenVideoAdDidPlayFinish:(MSExpressFullScreenVideoAd *)video withError:(NSError *)error{
    if (error) {
        self.statusLabel.text = @"播放发生错误";
        [self addDelegateString:[NSString stringWithFormat:@"[%@广告]播放发生错误%@",self.videoAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
    }else{
        self.statusLabel.text = @"播放完成";
        [self addDelegateString:[NSString stringWithFormat:@"[%@广告]播放完成%@",self.videoAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
    }
}
-(void)msExpressFullScreenVideoAdShowSuccess:(MSExpressFullScreenVideoAd *)video{
    self.statusLabel.text = @"展示成功";
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]展示成功%@",self.videoAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msExpressFullScreenVideoAdShowFailed:(MSExpressFullScreenVideoAd *)video withError:(NSError *)error{
    self.statusLabel.text = [NSString stringWithFormat:@"展示失败,错误：%@",error.localizedDescription];
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]展示失败%@",self.videoAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msExpressFullScreenVideoAdPlatformError:(MSPlatform)platform videoAd:(MSExpressFullScreenVideoAd *)video error:(NSError *)error{
    self.statusLabel.text = [NSString stringWithFormat:@"当前平台广告展示失败,错误：%@",error.localizedDescription];
    [self addDelegateString:[NSString stringWithFormat:@"当前广告展示失败,错误：%@%@",error.localizedDescription,NSStringFromSelector(_cmd)]];
}
-(void)msExpressFullScreenVideoAdDidSkip:(MSExpressFullScreenVideoAd *)video withPlayingProgress:(CGFloat)progress{
    self.statusLabel.text = @"点击跳过";
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]点击跳过%@",self.videoAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msExpressFullScreenVideoAdDidClick:(MSExpressFullScreenVideoAd *)video withPlayingProgress:(CGFloat)progress{
    self.statusLabel.text = @"广告被点击";
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]被点击%@",self.videoAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msExpressFullScreenVideoAdDidClose:(MSExpressFullScreenVideoAd *)video withPlayingProgress:(CGFloat)progress{
    self.statusLabel.text = @"广告被关闭";
    self.playBtn.enabled = NO;
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]已关闭%@",self.videoAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
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
        make.left.right.height.mas_equalTo(playBtn);
        make.bottom.mas_equalTo(self.view).offset(-60);
    }];
}
-(void)muteBtnClick:(UIButton *)sender{
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
-(void)dealloc{
    [MSLogger logString:[NSString stringWithFormat:@"%@-%@",NSStringFromClass(self.class),NSStringFromSelector(_cmd)] platform:-1];
}
@end
