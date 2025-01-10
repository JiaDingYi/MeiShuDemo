//
//  MSNativeFeedAdSimpleViewController.m
//  MSAdSDKDev
//
//  Created by leej on 2023/4/18.
//  Copyright © 2023 Adxdata. All rights reserved.
//

#import "MSNativeFeedAdSimpleViewController.h"
#import "MSNativeTestModel.h"
#import "MSNativeTestTableViewCell.h"
#import "MSNativeSimpleVideoAdView.h"
#import "MSNativeSimpleImageAdView.h"
#import "MSNativeFeedAdShowViewController.h"

@interface MSNativeFeedAdSimpleViewController ()<MSNativeFeedAdDelegate,
                                                MSNativeSimpleImageAdViewDelegate,
                                                MSNativeCustomVideoAdViewDelegate,
                                                MSNativeSimpleVideoAdViewDelegate,
                                                MSNativeFeedAdExtensionFunctionDelegate>

@property(nonatomic,strong) UIButton *refreshBtn;
@property(nonatomic,strong) UIButton *muteBtn;
@property(nonatomic,strong) UIButton *playBtn;
@property(nonatomic,strong) MSNativeFeedAd *nativeExpressAd;
@property(nonatomic,strong) UITextField *widthTF;
@property(nonatomic,strong) UITextField *heightTF;
@property(nonatomic,strong) UITextField *nativeTF;
@property(nonatomic,strong) UILabel *adInfoLabel;
@property(nonatomic,strong) UITextField *defaultPidTF;
@property(nonatomic,strong) MSNativeFeedAdShowViewController *showVC;

@end

@implementation MSNativeFeedAdSimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    self.defaultPidTF.text = self.defaultPid;
    self.adType = MSAdTypeNativeExpressAd;
}
- (void)refreshAd:(UIButton *)sender {
    [self loadNativeFeedAd];
}
-(void)loadNativeFeedAd{
    NSString *pid = @"1061831";
    MSNativeFeedAdConfigParams *adParam = [[MSNativeFeedAdConfigParams alloc]init];
    adParam.adCount = 1;
    adParam.edgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    adParam.videoMuted = self.muteBtn.selected;
    adParam.imageHeight = 80;
    adParam.isAutoPlay = self.playBtn.selected;
    adParam.prerenderAdSize = CGSizeMake(self.widthTF.text.floatValue, self.heightTF.text.floatValue);
    self.nativeExpressAd = [[MSNativeFeedAd alloc]init];
    self.nativeExpressAd.delegate = self;
    self.nativeExpressAd.extDelegate = self;
    [self.nativeExpressAd loadAdWithPid:pid adParam:adParam];
}
-(CGRect)nativeAdParams{
    NSString *frameStr = self.nativeTF.text;
    NSArray *frameArray = [frameStr componentsSeparatedByString:@","];
    if (frameArray.count == 4) {
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = 0;
        CGFloat h = 0;
        for (int index=0; index<frameArray.count; index++) {
            switch (index) {
                case 0:
                    x = [frameArray[index] floatValue];
                    break;
                case 1:
                    y = [frameArray[index] floatValue];
                    break;
                case 2:
                    w = [frameArray[index] floatValue];
                    break;
                case 3:
                    h = [frameArray[index] floatValue];
                    break;
                default:
                    break;
            }
        }
        return CGRectMake(x, y, w, h);
    }
    return CGRectZero;
}
#pragma mark delegate
-(void)msNativeFeedAdLoaded:(MSNativeFeedAd *)nativeFeedAd feedAds:(NSArray<MSNativeFeedAdModel *> *)feedAds{
    //获取广告信息
    NSMutableString *alertSring = [[NSMutableString alloc]init];
    [alertSring appendString:@"******本次广告信息******\n"];
    NSDictionary *adInfoDict = self.nativeExpressAd.mediaExt;
    for (NSString *key in adInfoDict.allKeys) {
        [alertSring appendString:[NSString stringWithFormat:@"%@ = %@\n",key,[adInfoDict objectForKey:key]]];
    }
    self.adInfoLabel.text = alertSring.copy;
    //获取广告结果集合
    NSArray *nativeAdDataArray = feedAds;
    NSMutableArray *tempArrM = [[NSMutableArray alloc]initWithCapacity:feedAds.count];
    if (nativeAdDataArray.count > 0) {
        for (int index=0; index<nativeAdDataArray.count; index++) {
            MSNativeFeedAdModel *obj = nativeAdDataArray[index];
            if (![obj isAdValid]) {
                continue;
            }
            //判断广告类型
            if (obj.isNativeExpress) {
                [tempArrM addObject:obj];
            }else{
                //如果是自渲染类型，转化成id<MSFeedAdMeta>类型读取广告信息
                id<MSFeedAdMeta> data = obj.adMaterialMeta;
                if (data.metaCreativeType != MSCreativeTypeVideo) {
                    [self addDelegateString:[NSString stringWithFormat:@"物料平台===%ld",(long)data.metaPlatform]];
                    MSNativeSimpleImageAdView *nativeAdView = [[MSNativeSimpleImageAdView alloc]initWithFeedAdMeta:data];
                    nativeAdView.delegate = self;
                    [tempArrM addObject:nativeAdView];
                }else{
                    MSNativeSimpleVideoAdView *video = [[MSNativeSimpleVideoAdView alloc]initWithFeedAdMeta:data];
                    video.delegate = self;
                    video.videoDelegate = self;
                    [tempArrM addObject:video];
                    [self addDelegateString:[NSString stringWithFormat:@"物料平台===%ld",(long)data.metaPlatform]];
                }
            }
        }
    }
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]加载成功%@",self.nativeExpressAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
    [self.navigationController pushViewController:self.showVC animated:YES];
    self.showVC.isMute = self.muteBtn.selected;
    [self.showVC reloadAdDataSource:tempArrM.copy];
    //此处模拟美数竞价成功或失败
    if ([self.nativeExpressAd.mediaExt[kMSAdMediaAdnPlatformKey]integerValue] != MSPlatformMS) {
        [self sendLossNotificationWithInfo:self.nativeExpressAd.mediaExt adLoader:self.nativeExpressAd];
    } else {
        [self sendWinNotificationWithInfo:self.nativeExpressAd.mediaExt adLoader:self.nativeExpressAd];
    }
}
-(void)msNativeFeedAdError:(MSNativeFeedAd *)nativeFeedAd withError:(NSError *)error{
    [self addDelegateString:[NSString stringWithFormat:@"广告拉取失败,错误：%@%@",error.localizedDescription,NSStringFromSelector(_cmd)]];
}
-(void)msNativeFeedAdMaterialMetaReadySuccess:(MSNativeFeedAd *)nativeFeedAd feedAd:(MSNativeFeedAdModel *)feedAd{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]预处理成功%@",self.nativeExpressAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msNativeFeedAdMaterialMetaReadyError:(MSNativeFeedAd *)nativeFeedAd feedAd:(MSNativeFeedAdModel *)feedAd error:(NSError *)error{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]预处理失败,错误：%@%@",self.nativeExpressAd.mediaExt[kMSAdMediaAdnNameKey],error.localizedDescription,NSStringFromSelector(_cmd)]];
    [self.showVC removeAdDataSource:feedAd];
}
-(void)msNativeFeedAdPlatformError:(MSPlatform)platform nativeFeedAd:(MSNativeFeedAd *)nativeFeedAd error:(NSError *)error{
    [self addDelegateString:[NSString stringWithFormat:@"当前平台模版广告展示失败,错误：%@%@",error.localizedDescription,NSStringFromSelector(_cmd)]];
}
-(void)msNativeFeedAdShow:(MSNativeFeedAdModel *)feedAd{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]展示成功%@",self.nativeExpressAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msNativeFeedAdClick:(MSNativeFeedAdModel *)feedAd{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]被点击%@",self.nativeExpressAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msNativeFeedAdDetailShow{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]进入详情页%@",self.nativeExpressAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msNativeFeedAdDetailClosed{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]详情页关闭%@",self.nativeExpressAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msNativeFeedAdClosed:(MSNativeFeedAdModel *)feedAd{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]模版广告已关闭%@",self.nativeExpressAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
    [self.showVC removeAdDataSource:feedAd];
}
-(void)msNativeFeedAdVideoStateDidChanged:(MSPlayerPlayState)playerState feedAd:(MSNativeFeedAdModel *)feedAd{
    NSString *statusStr = nil;
    switch (playerState) {
        case MSPlayerStateStarted:
            statusStr = @"开始播放";
            break;
        case MSPlayerStateFailed:
            statusStr = @"播放失败";
            break;
        case MSPlayerStatePlaying:
            statusStr = @"播放中";
            break;
        case MSPlayerStatePause:
            statusStr = @"暂停播放";
            break;
        case MSPlayerStateStopped:
            statusStr = @"播放完成";
            break;
        default:
            break;
    }
    [MSLogger logString:statusStr];
}
#pragma mark 自渲染组件回调
-(void)nativeSimpleImageAdViewClosed:(MSNativeCustomAdView *)adView{
    [self.showVC closeCustomRenderView:adView];
    [MSLogger logString:@"自渲染图文广告已关闭"];
}
-(void)nativeSimpleVideoAdViewClosed:(MSNativeCustomVideoAdView *)adView{
    [self.showVC closeCustomRenderView:adView];
    [MSLogger logString:@"自渲染视频广告已关闭"];
}
//视频播放完成
- (void)msFeedVideoFinish{
    [MSLogger logString:@"自渲染视频播放完成"];
}
//视频开始播放
- (void)msFeedVideoStart{
    [MSLogger logString:@"自渲染视频开始播放"];
}
//视频暂停播放
- (void)msFeedVideoPause{
    [MSLogger logString:@"自渲染视频暂停播放"];
}
//视频恢复播放
- (void)msFeedVideoResume{
    [MSLogger logString:@"自渲染视频恢复播放"];
}
//视频播放出错
- (void)msFeedVideoError:(NSError *)error{
    [MSLogger logString:@"自渲染视频播放出错"];
}
- (void)msFeedVideoPlayingProgress:(CGFloat)progress currentTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime { 
    
}
#pragma mark - SetUpView
-(void)setUpView{
    [self.adInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.top.mas_equalTo(self.view).offset(88);
    }];
    [self.nativeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.bottom.mas_equalTo(self.view).offset(-20);
    }];
    [self.defaultPidTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
    }];
    [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.bottom.mas_equalTo(self.muteBtn.mas_top).offset(-20);
        make.top.equalTo(self.defaultPidTF.mas_bottom).offset(20);
    }];
    [self.muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(self.refreshBtn);
        make.bottom.mas_equalTo(self.view).offset(-88);
        make.width.mas_equalTo(self.view.bounds.size.width/2-40);
    }];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.muteBtn.mas_right).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.height.top.mas_equalTo(self.muteBtn);
    }];
    [self.widthTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.defaultPidTF.mas_top).offset(-20);
        make.left.mas_equalTo(self.view).offset(20);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self.view.bounds.size.width/2-40);
    }];
    [self.heightTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.defaultPidTF.mas_top).offset(-20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self.view.bounds.size.width/2-40);
    }];
}
-(void)muteBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
}
-(void)playBtnClick:(UIButton *)sender{
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
        [self.view addSubview:_muteBtn];
    }
    return _muteBtn;
}
-(UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setTitle:@"关闭自动播放" forState:UIControlStateNormal];
        [_playBtn setTitle:@"开启自动播放" forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _playBtn.backgroundColor = [UIColor blueColor];
        _playBtn.selected = YES;
        [self.view addSubview:_playBtn];
    }
    return _playBtn;
}
-(UITextField *)widthTF{
    if (!_widthTF) {
        _widthTF = [MSQuickCreate defaultPidTextField];
        [self.view addSubview:_widthTF];
        _widthTF.keyboardType = UIKeyboardTypeNumberPad;
        _widthTF.placeholder = @"宽度";
    }
    return _widthTF;
}
-(UITextField *)heightTF{
    if (!_heightTF) {
        _heightTF = [MSQuickCreate defaultPidTextField];
        [self.view addSubview:_heightTF];
        _heightTF.keyboardType = UIKeyboardTypeNumberPad;
        _heightTF.placeholder = @"高度";
    }
    return _heightTF;
}
-(UITextField *)nativeTF{
    if (!_nativeTF) {
        _nativeTF = [MSQuickCreate defaultPidTextField];
        _nativeTF.placeholder = @"调整logo位置，按照x,y,w,h格式输入";
        [self.view addSubview:_nativeTF];
    }
    return _nativeTF;
}
-(UIButton *)refreshBtn{
    if (!_refreshBtn) {
        _refreshBtn = [MSQuickCreate longActionBtn];
        [_refreshBtn setTitle:@"刷新广告" forState:UIControlStateNormal];
        [_refreshBtn addTarget:self action:@selector(refreshAd:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_refreshBtn];
    }
    return _refreshBtn;
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
-(UITextField *)defaultPidTF{
    if (!_defaultPidTF) {
        _defaultPidTF = [MSQuickCreate defaultPidTextField];
        [self.view addSubview:_defaultPidTF];
    }
    return _defaultPidTF;
}
-(MSNativeFeedAdShowViewController *)showVC{
    if (!_showVC) {
        _showVC = [[MSNativeFeedAdShowViewController alloc]init];
    }
    return _showVC;
}
-(void)dealloc{
    [MSLogger logString:[NSString stringWithFormat:@"%@-%@",NSStringFromClass(self.class),NSStringFromSelector(_cmd)] platform:-1];
}
@end
