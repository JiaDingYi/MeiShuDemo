//
//  MSVideoAdViewController.m
//  MSAdSDKDev
//
//  Created by Liumaos on 2020/7/23.
//  Copyright © 2020 Adxdata. All rights reserved.
//

#import "MSVideoAdViewController.h"

@interface MSVideoAdViewController ()<MSVideoAdDelegate,MSVideoAdExtensionFunctionDelegate>

@property(nonatomic,strong) UITextField *defaultPidTF;
@property(nonatomic,strong) UISwitch *muteSwitch;
@property(nonatomic,strong) UISlider *sizeSlider;
@property(nonatomic,strong) UIView *containView;
@property(nonatomic,strong) UIButton * playBtn;
@property(nonatomic,strong) MSVideoAd *videoAd;
@property(nonatomic,strong) UIButton * showBtn;
@property(nonatomic,strong) UISlider *slider;
@property(nonatomic,strong) UILabel *sliderDec;
@property(nonatomic,strong) UILabel *muteDec;
@property(nonatomic,strong) UILabel *durationDec;
@property(nonatomic,strong) UILabel *currentDec;
@property(nonatomic,strong) NSTimer *timer;
@end

@implementation MSVideoAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    self.defaultPidTF.text = self.defaultPid;
    self.adType = MSAdTypePaster;
    [self.containView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(100);
        make.width.equalTo(@320);
        make.height.equalTo(@240);
        make.centerX.offset(0);
    }];
    [self.slider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(self.defaultPidTF.mas_top).offset(-30);
        make.height.equalTo(@20);
        make.width.equalTo(@200);
    }];
    [self.sliderDec mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.slider.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self.slider);
    }];
    [self.muteSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.slider);
        make.left.mas_equalTo(self.slider.mas_right).offset(20);
    }];
    [self.muteDec mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.muteSwitch.mas_bottom).offset(5);
        make.centerX.equalTo(self.muteSwitch);
    }];
    [self.defaultPidTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
    }];
    [self.showBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.defaultPidTF.mas_bottom);
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
    }];
    [self.playBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showBtn.mas_bottom);
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.bottom.offset(-60);
    }];
    [self.durationDec mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.containView.mas_left);
        make.top.mas_equalTo(self.containView.mas_bottom).offset(20);
    }];
    [self.currentDec mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.durationDec.mas_right).offset(20);
        make.top.mas_equalTo(self.durationDec);
    }];
}
-(void)loadAd{
    if (_videoAd) {
        [_videoAd removeFromSuperview];
        _videoAd = nil;
        [self.containView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(100);
            make.width.equalTo(@320);
            make.height.equalTo(@240);
            make.centerX.offset(0);
        }];
        [self.view layoutIfNeeded];
    }
    NSString *pid = self.defaultPidTF.text.length ? self.defaultPidTF.text : self.defaultPid;
    MSVideoAdConfigParams *param = [[MSVideoAdConfigParams alloc]init];
    param.adSize = CGSizeMake(320, 240);
    MSVideoAd *videoAd = [[MSVideoAd alloc]initWithFrame:CGRectMake(0, 0, 320, 240)];
    videoAd.delegate = self;
    videoAd.extDelegate = self;
    [videoAd loadAdWithPid:pid adConfigParams:param];
    self.videoAd = videoAd;
    self.playBtn.selected=NO;
}
-(void)countTime{
    self.currentDec.text = [NSString stringWithFormat:@"播放时长：%.02lfs",[self.videoAd currentTime]];
    self.durationDec.text = [NSString stringWithFormat:@"总时长：%.02lfs",[self.videoAd duration]];
}
-(void)muteClick:(UISwitch *)mute{
    self.videoAd.muted = mute.on;
}
- (void)playOrPauseAction:(UIButton *)sender {
    if (sender.selected) {
        [self.videoAd pauseVideo];
    }else{
        [self.videoAd playVideo];
    }
    sender.selected = !sender.selected;
}
- (void)changeFrame:(UISlider *)sender {
    CGFloat rate = sender.value;
    [self.videoAd reSize:CGRectMake(0, 0,self.containView.bounds.size.width * rate , self.containView.bounds.size.height * rate)];
}
#pragma mark- MSVideoAdDelegate
- (void)msVideoLoad:(MSVideoAd *)videoAd{
    self.durationDec.text = [NSString stringWithFormat:@"总时长：%lds",(long)[videoAd duration]];
    [self showAlert:videoAd.mediaExt];
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]视频广告加载成功%@",self.videoAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
    //此处模拟美数竞价成功或失败
    if ([videoAd.mediaExt[kMSAdMediaAdnPlatformKey]integerValue] != MSPlatformMS) {
        [self sendLossNotificationWithInfo:videoAd.mediaExt adLoader:videoAd];
    } else {
        [self sendWinNotificationWithInfo:videoAd.mediaExt adLoader:videoAd];
    }
}
-(void)msVideoReadySuccess:(MSVideoAd *)videoAd{
    if ([self.videoAd isAdValid]) {
        [self.containView addSubview:self.videoAd];
        [self.videoAd showAdWithPresentVc:self];
        [self msVideoResize:videoAd adSize:self.containView.bounds.size];
    }
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]视频广告准备就绪%@",self.videoAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
- (void)msVideoShow:(MSVideoAd *)videoAd{
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]视频广告展示成功%@",self.videoAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
- (void)msVideoError:(MSVideoAd *)videoAd
               error:(NSError *)error{
    [videoAd removeFromSuperview];
    [self addDelegateString:[NSString stringWithFormat:@"视频广告展示失败,错误：%@%@",error.localizedDescription,NSStringFromSelector(_cmd)]];
}
-(void)msVideoPlatformError:(MSPlatform)platform
                         ad:(MSVideoAd *)videoAd
                      error:(NSError *)error{
    [self addDelegateString:[NSString stringWithFormat:@"当前平台视频广告展示失败,错误：%@%@",error.localizedDescription,NSStringFromSelector(_cmd)]];
}
- (void)msVideoClick:(MSVideoAd *)videoAd{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]视频广告被点击%@",self.videoAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
- (void)msVideoClose:(MSVideoAd *)videoAd{
    [self.timer invalidate];
    self.timer = nil;
    [self.videoAd removeFromSuperview];
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]视频广告被关闭%@",self.videoAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msVideoResize:(MSVideoAd *)videoAd adSize:(CGSize)adSize{
    self.videoAd.frame = CGRectMake(0, 0, adSize.width, adSize.height);
    [self.containView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(100);
        make.size.mas_equalTo(adSize);
        make.centerX.offset(0);
    }];
    [self.containView layoutIfNeeded];
}
- (void)msVideoCompletion:(MSVideoAd *)videoAd{
    [self.timer invalidate];
    self.timer = nil;
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]视频广告播放完成%@",self.videoAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
#pragma mark -SetUpView
-(void)setUpView{
    self.containView = [[UIView alloc]initWithFrame:CGRectZero];
    self.containView.layer.borderWidth   = 0.5;
    self.containView.layer.borderColor   = [UIColor lightGrayColor].CGColor;
    self.containView.layer.cornerRadius  = 2;
    self.containView.layer.masksToBounds = YES;
    [self.view addSubview:self.containView];
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectZero];
    slider.maximumValue = 1;
    slider.minimumValue = 0.6;
    [slider addTarget:self action:@selector(changeFrame:) forControlEvents:UIControlEventValueChanged];
    slider.value = 1.0;
    self.slider = slider;
    [self.view addSubview:slider];
    UILabel *sliderDec = [MSQuickCreate statusLabel];
    self.sliderDec = sliderDec;
    sliderDec.text = @"调整尺寸";
    [self.view addSubview:sliderDec];
    UISwitch *muteSwitch = [[UISwitch alloc]init];
    [self.view addSubview:muteSwitch];
    self.muteSwitch = muteSwitch;
    [self.muteSwitch addTarget:self
                        action:@selector(muteClick:)
              forControlEvents:UIControlEventValueChanged];
    UILabel *muteDec = [MSQuickCreate statusLabel];
    muteDec.text = @"是否静音";
    self.muteDec = muteDec;
    [self.view addSubview:muteDec];
    self.durationDec = [MSQuickCreate statusLabel];
    [self.view addSubview:self.durationDec];
    self.currentDec = [MSQuickCreate statusLabel];
    [self.view addSubview:self.currentDec];
    self.defaultPidTF = [MSQuickCreate defaultPidTextField];
    [self.view addSubview:self.defaultPidTF];
    UIButton * showBtn = [MSQuickCreate longActionBtn];
    [showBtn setTitle:@"加载广告" forState:UIControlStateNormal];
    [showBtn addTarget:self
                action:@selector(loadAd)
      forControlEvents:UIControlEventTouchUpInside];
    self.showBtn = showBtn;
    [self.view addSubview:showBtn];
    self.playBtn = [MSQuickCreate longActionBtn];
    [self.playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [self.playBtn setTitle:@"暂停" forState:UIControlStateSelected];
    [self.playBtn addTarget:self
                action:@selector(playOrPauseAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playBtn];
}
-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
    [MSLogger logString:[NSString stringWithFormat:@"%@-%@",NSStringFromClass(self.class),NSStringFromSelector(_cmd)] platform:-1];
}
@end
