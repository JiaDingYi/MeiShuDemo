//
//  MSBannerViewController.m
//  MSAdSDKDev
//
//  Created by Liumaos on 2020/7/21.
//  Copyright © 2020 Adxdata. All rights reserved.
//

#import "MSBannerViewController.h"

@interface MSBannerViewController ()<MSBannerViewDelegate,MSBannerViewExtensionFunctionDelegate>

@property(nonatomic,strong) UIView *containView;
@property(nonatomic,strong) MSBannerView *bannerView;
@property(nonatomic,strong) UIButton *showCloseBtn;
@property(nonatomic,strong) UIButton * removeBtn;
@property(nonatomic,strong) UIButton * showBtn;
@property(nonatomic,strong) UITextField *defaultPidTF;
@end

@implementation MSBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    self.defaultPidTF.text = self.defaultPid;
    self.showCloseBtn.selected = YES;
    self.adType = MSAdTypeBanner;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //在不需要展示banner地方 调用dismiss 避免出现广告无法释放问题 此处时机仅做demo调试使用
    if (_bannerView && self.navigationController == nil) {
        [_bannerView dismiss];
        _bannerView = nil;
    }
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    BOOL isScreenH = self.view.bounds.size.width > self.view.bounds.size.height;
    [self.containView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(isScreenH ? 64 : 100);
        make.width.equalTo(@300);
        make.height.equalTo(@75);
        make.centerX.offset(0);
    }];
    [self.defaultPidTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
    }];
    [self.showBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.top.equalTo(self.defaultPidTF.mas_bottom).offset(isScreenH ? 0 : 20);
    }];
    [self.removeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.top.equalTo(self.showBtn.mas_bottom).offset(isScreenH ? 0 : 20);
    }];
    [self.showCloseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.bottom.offset(-60);
        make.top.equalTo(self.removeBtn.mas_bottom).offset(isScreenH ? 0 : 20);
    }];
}
-(MSBannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[MSBannerView alloc]initWithFrame:self.containView.bounds];
    }
    return _bannerView;
}
- (void)showBannerAd:(id)sender {
    NSString *pid = @"1061833";
    MSBannerAdConfigParams *adParam = [[MSBannerAdConfigParams alloc]init];
    adParam.showCloseBtn = YES;
    self.bannerView.delegate = self;
    self.bannerView.extDelegate = self;
    [self.bannerView loadAdAndShowWithPid:pid presentVC:self adParams:adParam];
    self.showCloseBtn.selected=YES;
}
- (void)removeBannerAd:(id)sender {
    self.showCloseBtn.selected=YES;
    [self.bannerView dismiss];
    self.bannerView = nil;
}
- (void)showOrHideCloseBtn:(UIButton*)sender {
    sender.selected = !sender.selected;
    [self.bannerView showCloseBtn:!sender.selected];
}
-(void)msBannerShow:(MSBannerView *)msBannerAd{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]横幅广告已展现%@",self.bannerView.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msBannerClosed:(MSBannerView *)msBannerAd{
    [self.bannerView dismiss];
    _bannerView = nil;
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]横幅广告已关闭%@",self.bannerView.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msBannerClicked:(MSBannerView *)msBannerAd{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]横幅广告被点击%@",self.bannerView.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msBannerDetailShow:(MSBannerView *)msBannerAd{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]横幅广告进入详情页%@",self.bannerView.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msBannerError:(MSBannerView *)msBannerAd error:(NSError *)error{
    [self addDelegateString:[NSString stringWithFormat:@"横幅广告展示失败,错误：%@%@",error.localizedDescription,NSStringFromSelector(_cmd)]];
}
-(void)msBannerDetailClosed:(MSBannerView *)msBannerAd{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]横幅广告详情页已关闭%@",self.bannerView.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msBannerAdReadySuccess:(MSBannerView *)msBannerAd{
    if (!self.bannerView.superview) {
        [self.containView addSubview:_bannerView];
    }
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]横幅广告准备就绪%@",self.bannerView.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msBannerAdRenderSuccess:(MSBannerView *)msBannerAd{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]横幅广告渲染成功%@",self.bannerView.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msBannerAdRenderFail:(MSBannerView *)msBannerAd error:(NSError *)error{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]横幅广告渲染失败%@",self.bannerView.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
#pragma mark MSBannerViewExtensionFunctionDelegate
-(void)msBannerLoaded:(MSBannerView *)msBannerAd{
    [self showAlert:msBannerAd.mediaExt];
    //此处模拟美数竞价成功或失败
    if ([msBannerAd.mediaExt[kMSAdMediaAdnPlatformKey]integerValue] != MSPlatformMS) {
        [self sendLossNotificationWithInfo:msBannerAd.mediaExt adLoader:msBannerAd];
    } else {
        [self sendWinNotificationWithInfo:msBannerAd.mediaExt adLoader:msBannerAd];
    }
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]横幅广告加载成功%@",self.bannerView.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msBannerPlatformError:(MSPlatform)platform
                    bannerAd:(MSBannerView *)msBannerAd
                       error:(NSError *)error{
    [self addDelegateString:[NSString stringWithFormat:@"当前平台横幅广告展示失败,错误：%@%@",error.localizedDescription,NSStringFromSelector(_cmd)]];
}
#pragma mark -SetUpView
-(void)setUpView{
    self.containView  = [[UIView alloc]initWithFrame:CGRectZero];
    self.containView.layer.borderWidth   = 0.5;
    self.containView.layer.borderColor   = [UIColor lightGrayColor].CGColor;
    self.containView.layer.cornerRadius  = 3;
    self.containView.layer.masksToBounds = YES;
    [self.view addSubview:self.containView];
    
    self.defaultPidTF = [MSQuickCreate defaultPidTextField];
    [self.view addSubview:self.defaultPidTF];
    
    UIButton * showBtn = [MSQuickCreate longActionBtn];
    [showBtn setTitle:@"展示广告" forState:UIControlStateNormal];
    [showBtn addTarget:self
                action:@selector(showBannerAd:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showBtn];
    self.showBtn = showBtn;
    
    UIButton * removeBtn = [MSQuickCreate longActionBtn];
    [removeBtn setTitle:@"移除广告" forState:UIControlStateNormal];
    [removeBtn addTarget:self
                  action:@selector(removeBannerAd:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:removeBtn];
    self.removeBtn = removeBtn;
    
    UIButton * showCloseBtn = [MSQuickCreate longActionBtn];
    [showCloseBtn setTitle:@"显示 关闭按钮" forState:UIControlStateSelected];
    [showCloseBtn setTitle:@"隐藏 关闭按钮" forState:UIControlStateNormal];
    [showCloseBtn addTarget:self
                     action:@selector(showOrHideCloseBtn:)
           forControlEvents:UIControlEventTouchUpInside];
    self.showCloseBtn = showCloseBtn;
    [self.view addSubview:showCloseBtn];
    BOOL isScreenH = self.view.bounds.size.width > self.view.bounds.size.height;
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(100);
        make.width.equalTo(@300);
        make.height.equalTo(@75);
        make.centerX.offset(0);
    }];
    [self.defaultPidTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
    }];
    [showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.top.equalTo(self.defaultPidTF.mas_bottom).offset(isScreenH ? 0 : 20);
    }];
    [removeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.top.equalTo(showBtn.mas_bottom).offset(isScreenH ? 0 : 20);
    }];
    [self.showCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.leading.offset(20);
        make.trailing.offset(-20);
        make.bottom.offset(-60);
        make.top.equalTo(removeBtn.mas_bottom).offset(isScreenH ? 0 : 20);
    }];
}
-(void)dealloc{
    [MSLogger logString:[NSString stringWithFormat:@"%@-%@",NSStringFromClass(self.class),NSStringFromSelector(_cmd)] platform:-1];
}
@end
