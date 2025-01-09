//
//  MSSplashViewController.m
//  MSAdSDKDev
//
//  Created by Liumaos on 2020/7/17.
//  Copyright © 2020 XiXiHaha. All rights reserved.
//

#import "MSSplashViewController.h"
#import "MSSplashSettingView.h"

@interface MSSplashViewController ()<MSSplashAdDelegate,MSSplashAdExtensionFuctionDelegate,MSSplashSettingViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)MSSplashAd *splash;
@property(nonatomic,assign)BOOL isSuccess;
@property(nonatomic,strong)UIButton *settingsBtn;
@property(nonatomic,strong)UIButton *fullBtn;
@property(nonatomic,strong)UIButton *halfBtn;
@property(nonatomic,strong)UILabel *customSkipView;
@property(nonatomic,strong)UILabel *logoView;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)MSSplashSettingView *splashSettingView;
@property(nonatomic,strong)NSArray<NSString *> *adCats;
@property(nonatomic,strong)NSArray<NSString *> *adCids;
@property(nonatomic,strong)NSArray<NSString *> *aderIds;
@property(nonatomic,strong)UIPickerView *selectView;
@property(nonatomic,strong)NSArray *selectPids;
@property(nonatomic,strong) UITextField *pidTF;
@end

@implementation MSSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bottomView];
    self.pidTF = [MSQuickCreate defaultPidTextField];
    self.pidTF.placeholder = @"请输入pid";
    [self.view addSubview:self.pidTF];
    [self.settingsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.mas_equalTo(self.halfBtn);
        make.bottom.mas_equalTo(self.view).offset(-20);
    }];
    [self.pidTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.bottom.mas_equalTo(self.fullBtn.mas_top).offset(-20);
    }];
    [self.fullBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.bottom.equalTo(self.halfBtn.mas_top).offset(-20);
    }];
    [self.halfBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.bottom.equalTo(self.settingsBtn.mas_top).offset(-20);
    }];
    [self resetButton];
    self.adType = MSAdTypeSplash;
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if (self.settingsBtn.selected) {
        self.splashSettingView.frame = CGRectMake(0, self.view.bounds.size.height - 260, self.view.bounds.size.width, 260);
    }else{
        self.splashSettingView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 0);
    }
    _customSkipView.frame = CGRectMake(self.view.bounds.size.width-90,isMSIPhoneXSeries()?44:20, 70, 40);
}
- (void)clickLoadFull:(UIButton*)sender{
    self.halfBtn.enabled = NO;
    if ([self.fullBtn.titleLabel.text isEqualToString:@"展示广告"]) {
        [self.splash showSplashAdInWindow:[UIApplication sharedApplication].keyWindow];
        return;
    }
    if (!self.isSuccess) {
        self.splash = nil;
    }
    MSSplashAdConfigParams *adParam = nil;
    NSString *pid = @"1061834";
    if (self.pidTF.text.length > 0) {
        pid = self.pidTF.text;
    }
    if (!self.splash) {
        self.splash = [[MSSplashAd alloc]init];
        adParam = [[MSSplashAdConfigParams alloc]init];
        adParam.adSize = self.view.bounds.size;
        adParam.hideSplashStatusBar = YES;
        adParam.hideSkipButton = self.splashSettingView.hideSkipView;
        adParam.splashClickText = self.splashSettingView.openThirdWords ? @"点击前往第三方页面 >" : @"";
        adParam.fetchDelay = self.splashSettingView.timeOut;
        adParam.skipView = self.splashSettingView.showSkipView ? self.customSkipView : nil;
        self.splash.delegate = self;
        self.splash.extDelegate = self;
    }
    if (self.splashSettingView.loadAndShow) {
        [self.splash loadAndShowSplashAdWithPid:pid adParam:adParam inWindow:[UIApplication sharedApplication].keyWindow];
    }else{
        [self.splash loadSplashAdWithPid:pid adParam:adParam];
    }
    self.loadTime = [[NSDate date]timeIntervalSince1970];
}
- (void)clickLoadHalf:(UIButton*)sender{
    self.fullBtn.enabled=NO;
    if ([self.halfBtn.titleLabel.text isEqualToString:@"展示广告"]) {
        [self.splash showSplashAdInWindow:[UIApplication sharedApplication].keyWindow];
        return;
    }
    if (!self.isSuccess) {
        self.splash = nil;
    }
    MSSplashAdConfigParams *adParam = nil;
    NSString *pid = self.defaultPid;
    if (self.pidTF.text.length > 0) {
        pid = self.pidTF.text;
    }
    if (!self.splash) {
        self.splash = [[MSSplashAd alloc]init];
        adParam = [[MSSplashAdConfigParams alloc]init];
        adParam.hideSplashStatusBar = YES;
        adParam.hideSkipButton = self.splashSettingView.hideSkipView;
        adParam.splashClickText = self.splashSettingView.openThirdWords ? @"点击前往第三方页面 >" : @"";
        adParam.fetchDelay = self.splashSettingView.timeOut;
        adParam.skipView = self.splashSettingView.showSkipView ? self.customSkipView : nil;
        adParam.bottomView = [self bottomView];
        adParam.adSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-adParam.bottomView.bounds.size.height);
        self.splash.delegate = self;
        self.splash.extDelegate = self;
    }
    if (self.splashSettingView.loadAndShow) {
        [self.splash loadAndShowSplashAdWithPid:pid adParam:adParam inWindow:[UIApplication sharedApplication].keyWindow];
    }else{
        [self.splash loadSplashAdWithPid:pid adParam:adParam];
    }
    self.loadTime = [[NSDate date]timeIntervalSince1970];
}
-(UIView *)bottomView{
    if (!_bottomView) {
        CGFloat screenWidth  = [UIScreen mainScreen].bounds.size.width;
        UIView * bottomView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0)];
        bottomView.backgroundColor = UIColor.whiteColor;
        [bottomView addSubview:self.logoView];
        [self.logoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(bottomView);
        }];
        _bottomView = bottomView;
    }
    return _bottomView;
}
#pragma mark- <MSSplashAdDelegate>
- (void)msSplashClicked:(MSSplashAd *)splashAd {
    self.isSuccess=NO;
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]开屏广告被点击%@",self.splash.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
- (void)msSplashClosed:(MSSplashAd *)splashAd {
    self.isSuccess = NO;
    [self resetButton];
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]开屏广告已经关闭%@",self.splash.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
- (void)msSplashDetailClosed:(MSSplashAd *)splashAd {
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]开屏广告详情页关闭%@",self.splash.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
- (void)msSplashError:(MSSplashAd *)splashAd withError:(NSError *)error {
    self.isSuccess = NO;
    [self resetButton];
    [self addDelegateString:[NSString stringWithFormat:@"开屏广告展示失败,错误：%@----%@",error.localizedDescription,NSStringFromSelector(_cmd)]];
}
-(void)msSplashPresent:(MSSplashAd *)splashAd{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]开屏广告展示成功%@",self.splash.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
- (void)msSplashShow:(MSSplashAd *)splashAd {
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]开屏广告已经展示%@",self.splash.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
- (void)msSplashSkip:(MSSplashAd *)splashAd {
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]开屏广告点击跳过%@",self.splash.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
- (void)msSplashWillClosed:(MSSplashAd *)splashAd {
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]开屏广告将要关闭%@",self.splash.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
- (void)msSplashStartLoaded:(MSSplashAd *)splashAd currentLoadPlatform:(MSPlatform)loadPlatform{
    [self addDelegateString:[NSString stringWithFormat:@"开屏广告开始加载%@",NSStringFromSelector(_cmd)]];
}
//如果开屏广告加载和展示分离，请在收到准备就绪回调后调用show接口
-(void)msSplashAdReadySuccess:(MSSplashAd *)splashAd{
    [self showAlert:splashAd.mediaExt];
    self.loadSuccessTime = [[NSDate date]timeIntervalSince1970];
    self.isSuccess = YES;
    if (self.fullBtn.enabled) {
        [self.fullBtn setTitle:@"展示广告" forState:UIControlStateNormal];
    }
    if (self.halfBtn.enabled) {
        [self.halfBtn setTitle:@"展示广告" forState:UIControlStateNormal];
    }
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]开屏广告展示准备就绪%@",self.splash.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
    //此处模拟美数竞价成功或失败
    if ([splashAd.mediaExt[kMSAdMediaAdnPlatformKey]integerValue] != MSPlatformMS) {
        [self sendLossNotificationWithInfo:splashAd.mediaExt adLoader:splashAd];
    } else {
        [self sendWinNotificationWithInfo:splashAd.mediaExt adLoader:splashAd];
    }
}
-(void)msSplashAdShowFail:(MSSplashAd *)splashAd error:(NSError *)error{
    self.isSuccess = NO;
    [self resetButton];
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]开屏广告展示失败%@",self.splash.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}

#pragma mark MSSplashAdExtensionFuctionDelegate

-(void)msSplashPlatformError:(MSPlatform)platform
                    splashAd:(MSSplashAd *)splashAd
                       error:(NSError *)error{
    [self addDelegateString:[NSString stringWithFormat:@"当前平台开屏广告展示失败,错误：%@----%@",error.localizedDescription,NSStringFromSelector(_cmd)]];
}
- (void)msSplashLoaded:(MSSplashAd *)splashAd {
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]开屏广告加载成功%@",self.splash.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
#pragma mark -SetUpView
-(void)resetButton{
    self.fullBtn.enabled=YES;
    self.halfBtn.enabled=YES;
    [self.fullBtn setTitle:@"全屏展示" forState:UIControlStateNormal];
    [self.halfBtn setTitle:@"半屏展示" forState:UIControlStateNormal];
}
-(void)adjustBottomViewHeight:(CGFloat)height{
    if (self.bottomView) {
        self.bottomView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height);
    }
}
-(void)settingsBtnClick:(UIButton *)btn{
    self.splashSettingView.hidden = NO;
    btn.selected = !btn.selected;
    if (btn.selected) {
        [UIView animateWithDuration:0.2 animations:^{
            self.splashSettingView.frame = CGRectMake(0, self.view.bounds.size.height - 260, self.view.bounds.size.width, 260);
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.splashSettingView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 0);
        }];
    }
}
-(void)settingsTapClick{
    if (self.settingsBtn.selected) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        self.splashSettingView.frame = CGRectMake(0, (size.width > size.height)?-self.view.bounds.size.height:self.view.bounds.size.height, self.view.bounds.size.width, 0);
        self.settingsBtn.selected = NO;
    }
}
-(void)defaultPidTFClick{
    [UIView animateWithDuration:0.2 animations:^{
        self.selectView.frame = CGRectMake(0, self.view.bounds.size.height-200, self.view.bounds.size.width, 200);
    }];
}
#pragma mark UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.selectPids.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.selectPids[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *pid = self.selectPids[row];
    [UIView animateWithDuration:0.2 animations:^{
        self.selectView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.frame.size.width, 0);
    }completion:^(BOOL finished) {
        self.defaultPid = [pid componentsSeparatedByString:@"pid:"].lastObject;
        [MSLogger logString:pid platform:-1];
    }];
}
-(UILabel *)customSkipView{
    if (!_customSkipView) {
        _customSkipView = [[UILabel alloc]init];
        _customSkipView.text = @"跳过";
        _customSkipView.font = [UIFont systemFontOfSize:20 weight:10];
        _customSkipView.frame = CGRectMake(self.view.bounds.size.width-90,isMSIPhoneXSeries()?44:20, 70, 40);
        _customSkipView.backgroundColor = [UIColor whiteColor];
        _customSkipView.textAlignment = NSTextAlignmentCenter;
        _customSkipView.layer.cornerRadius = 20;
        _customSkipView.layer.masksToBounds = YES;
        _customSkipView.alpha=0.6;
    }
    return _customSkipView;
}
-(UILabel *)logoView{
    if (!_logoView) {
        _logoView = [[UILabel alloc] init];
        _logoView.text = @"logo 展示区域";
        _logoView.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    }
    return _logoView;
}
-(MSSplashSettingView *)splashSettingView{
    if (!_splashSettingView) {
        _splashSettingView = [[MSSplashSettingView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 0)];
        _splashSettingView.delegate = self;
        [self.view addSubview:_splashSettingView];
    }
    return _splashSettingView;
}
-(UIButton *)settingsBtn{
    if (!_settingsBtn) {
        _settingsBtn = [MSQuickCreate longActionBtn];
        [_settingsBtn addTarget:self action:@selector(settingsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_settingsBtn];
        [_settingsBtn setTitle:@"设置开屏参数" forState:UIControlStateNormal];
        [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(settingsTapClick)]];
    }
    return _settingsBtn;
}
-(UIButton *)fullBtn{
    if (!_fullBtn) {
        _fullBtn = [MSQuickCreate longActionBtn];
        [_fullBtn addTarget:self
                    action:@selector(clickLoadFull:)
          forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_fullBtn];
    }
    return _fullBtn;
}
-(UIButton *)halfBtn{
    if (!_halfBtn) {
        _halfBtn = [MSQuickCreate longActionBtn];
        [_halfBtn addTarget:self
                  action:@selector(clickLoadHalf:)
        forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_halfBtn];
    }
    return _halfBtn;
}
- (UIPickerView *)selectView{
    if (_selectView == nil) {
        _selectView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.frame.size.width, 0)];
        _selectView.backgroundColor = [[UIColor alloc]initWithRed:141/255.0 green:210/255.0 blue:246/255.0 alpha:1];
        _selectView.delegate = self;
        _selectView.dataSource = self;
        [self.view addSubview:_selectView];
    }
    return _selectView;
}
-(NSArray *)selectPids{
    if (!_selectPids) {
        _selectPids = @[];
    }
    return _selectPids;
}
-(void)dealloc{
    [MSLogger logString:[NSString stringWithFormat:@"%@-%@",NSStringFromClass(self.class),NSStringFromSelector(_cmd)] platform:-1];
}

@end
