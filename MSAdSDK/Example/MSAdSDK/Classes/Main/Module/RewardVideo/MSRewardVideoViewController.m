//
//  MSRewardVideoViewController.m
//  MSAdSDKDev
//
//  Created by Liumaos on 2020/7/20.
//  Copyright © 2020 XiXiHaha. All rights reserved.
//

#import "MSRewardVideoViewController.h"

@interface MSRewardVideoViewController ()<MSRewardVideoAdDelegate,MSRewardVideoAdExtensionFunctionDelegate>
@property(nonatomic,strong) UIButton *showCloseBtn;
@property(nonatomic,strong) UIButton *loadBtn;
@property(nonatomic,strong) UIButton *muteBtn;
@property(nonatomic,strong) UIButton *playBtn;
@property(nonatomic,strong) UILabel *statusLabel;
@property(nonatomic,strong) MSRewardVideoAd *rewardAd;
@property(nonatomic,strong) UITextField *defaultPidTF;

@end

@implementation MSRewardVideoViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    self.defaultPidTF.text        = self.defaultPid;
    self.defaultPidTF.placeholder = self.defaultPid;
    self.playBtn.enabled          = NO;
    self.adType = MSAdTypeReward;
}
#pragma mark 加载广告
-(void)loadAd:(id)sender {
    self.statusLabel.text = @"正在加载....";
    self.playBtn.enabled  = NO;
    NSString *pid = @"1061836";
    MSRewardAdConfigParams *adParam = [[MSRewardAdConfigParams alloc]init];
    adParam.userId = @"ms";
    adParam.videoMuted = self.muteBtn.selected;
    adParam.direction = MSRewardAdShowHorizontalDirection;
    self.rewardAd = [[MSRewardVideoAd alloc]init];
    self.rewardAd.delegate = self;
    self.rewardAd.extDelegate = self;
    [self.rewardAd loadRewardVideoAdWithPid:pid adConfigParams:adParam];
}
#pragma mark 展示广告
-(void)playAd:(id)sender {
    if ([self.rewardAd isAdValid]) {
        [self.rewardAd showRewardVideoAdFromRootViewController:self];
    }else{
        self.statusLabel.text = @"激励视频无效，重新拉取广告";
        [self msRewardVideoPlayingError:self.rewardAd error:[NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:@{}]];
    }
}
#pragma mark- MSRewardVideoAdDelegat
-(void)msRewardVideoLoaded:(MSRewardVideoAd *)msRewardVideoAd {
    self.statusLabel.text = @"广告已加载";
    [self showAlert:msRewardVideoAd.mediaExt];
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]激励视频加载成功%@",self.rewardAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
    //此处模拟美数竞价成功或失败
    if ([msRewardVideoAd.mediaExt[kMSAdMediaAdnPlatformKey]integerValue] != MSPlatformMS) {
        [self sendLossNotificationWithInfo:msRewardVideoAd.mediaExt adLoader:msRewardVideoAd];
    } else {
        [self sendWinNotificationWithInfo:msRewardVideoAd.mediaExt adLoader:msRewardVideoAd];
    }
}
-(void)msRewardVideoCached:(MSRewardVideoAd *)msRewardVideoAd {
    self.playBtn.enabled  = YES;
    self.statusLabel.text = @"广告视频已缓存";
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]激励视频已缓存%@",self.rewardAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msRewardVideoClicked:(MSRewardVideoAd *)msRewardVideoAd {
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]激励视频被点击%@",self.rewardAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msRewardVideoClosed:(MSRewardVideoAd *)msRewardVideoAd {
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]激励视频已关闭%@",self.rewardAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
    self.playBtn.enabled=NO;
}
-(void)msRewardVideoError:(MSRewardVideoAd *)msRewardVideoAd error:(NSError *)error {
    self.statusLabel.text = @"广告加载失败，稍后重试";
    [self addDelegateString:[NSString stringWithFormat:@"激励视频展示失败%@%@",error.localizedDescription,NSStringFromSelector(_cmd)]];
}
-(void)msRewardVideoFinish:(MSRewardVideoAd *)msRewardVideoAd {
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]激励视频播放完成%@",self.rewardAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msRewardVideoReward:(MSRewardVideoAd *)msRewardVideoAd extInfo:(NSDictionary *)adInfo{
    if ([[adInfo valueForKey:@"rewardVerify"]boolValue]) {
        NSString *rewardAmount = [adInfo objectForKey:@"rewardAmount"];
        NSString *rewardName = [adInfo objectForKey:@"rewardName"];
        self.statusLabel.text =[NSString stringWithFormat:@"奖励数量:%@--奖励名称:%@",rewardAmount.length > 0? rewardAmount:@"暂无",rewardName.length>0?rewardName:@"暂无"];
        [self addDelegateString:[NSString stringWithFormat:@"[%@广告]激励视频发放奖励成功%@",self.rewardAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
    }else{
        self.statusLabel.text = @"激励视频发放奖励失败";
        [self addDelegateString:[NSString stringWithFormat:@"[%@广告]激励视频发放奖励失败%@",self.rewardAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
    }
}
-(void)msRewardVideoShow:(MSRewardVideoAd *)msRewardVideoAd {
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]激励视频展示成功%@",self.rewardAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msRewardVideoWillShow:(MSRewardVideoAd *)msRewardVideoAd {
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]激励视频将要展示%@",self.rewardAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msRewardVideoRenderSuccess:(MSRewardVideoAd *)msRewardVideoAd{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]激励视频渲染成功%@",self.rewardAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msRewardVideoRenderFail:(MSRewardVideoAd *)msRewardVideoAd error:(NSError *)error{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]激励视频渲染失败%@",self.rewardAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msRewardVideoStopPlaying:(MSRewardVideoAd *)msRewardVideoAd{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]激励视频暂停播放%@",self.rewardAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msRewardVideoStartPlaying:(MSRewardVideoAd *)msRewardVideoAd{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]激励视频开始播放%@",self.rewardAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msRewardVideoResumePlaying:(MSRewardVideoAd *)msRewardVideoAd{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]激励视频恢复播放%@",self.rewardAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msRewardVideoClickSkip:(MSRewardVideoAd *)msRewardVideoAd currentTime:(NSTimeInterval)currentTime{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]激励视频点击跳过%@",self.rewardAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msRewardVideoPlayingError:(MSRewardVideoAd *)msRewardVideoAd error:(NSError *)error{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]激励视频播放错误%@",self.rewardAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
    self.playBtn.enabled=NO;
}

#pragma mark MSRewardVideoAdExtensionFunctionDelegate

-(void)msRewardVideoPlatformError:(MSRewardVideoAd *)msRewardVideoAd
                         platform:(MSPlatform)platform
                            error:(NSError *)error{
    [self addDelegateString:[NSString stringWithFormat:@"当前平台激励视频展示失败%@%@",error.localizedDescription,NSStringFromSelector(_cmd)]];
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
    self.loadBtn = loadBtn;
    UIButton * playBtn = [MSQuickCreate longActionBtn];
    [playBtn setTitle:@"展示广告" forState:UIControlStateNormal];
    [playBtn addTarget:self
              action:@selector(playAd:)
    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    self.playBtn = playBtn;
    self.statusLabel = [MSQuickCreate statusLabel];
    [self.view addSubview:self.statusLabel];
    self.statusLabel.numberOfLines = 0;
    [self.view addSubview:self.showCloseBtn];
    [self.view addSubview:self.muteBtn];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(self.view);
        make.bottom.equalTo(self.defaultPidTF.mas_top).offset(-20);
    }];
    [self.defaultPidTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.bottom.mas_equalTo(loadBtn.mas_top).offset(-20);
    }];
    [loadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.bottom.equalTo(playBtn.mas_top).offset(-20);
    }];
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.bottom.equalTo(self.showCloseBtn.mas_top).offset(-20);
    }];
    [self.showCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.bottom.mas_equalTo(self.muteBtn.mas_top).offset(-20);
    }];
    [self.muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.bottom.mas_equalTo(self.view).offset(-20);
    }];
}
-(void)showCloseBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
}
-(void)muteBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
}
-(UIButton *)showCloseBtn{
    if (!_showCloseBtn) {
        _showCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showCloseBtn setTitle:@"播放途中不展示关闭按钮" forState:UIControlStateNormal];
        [_showCloseBtn setTitle:@"播放途中展示关闭按钮" forState:UIControlStateSelected];
        [_showCloseBtn addTarget:self action:@selector(showCloseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _showCloseBtn.backgroundColor = [UIColor blueColor];
    }
    return _showCloseBtn;
}
-(UIButton *)muteBtn{
    if (!_muteBtn) {
        _muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_muteBtn setTitle:@"未开启静音" forState:UIControlStateNormal];
        [_muteBtn setTitle:@"已开启静音" forState:UIControlStateSelected];
        [_muteBtn addTarget:self action:@selector(muteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _muteBtn.backgroundColor = [UIColor blueColor];
    }
    return _muteBtn;
}
-(void)dealloc{
    [MSLogger logString:[NSString stringWithFormat:@"%@-%@",NSStringFromClass(self.class),NSStringFromSelector(_cmd)] platform:-1];
}
@end
