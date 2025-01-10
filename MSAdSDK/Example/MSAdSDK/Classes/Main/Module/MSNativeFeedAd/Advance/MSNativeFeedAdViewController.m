//
//  MSNativeFeedAdViewController.m
//  MSAdSDKDev
//
//  Created by leej on 2021/8/1.
//  Copyright © 2021 Adxdata. All rights reserved.
//

#import "MSNativeFeedAdViewController.h"
#import "MSNativeTestModel.h"
#import "MSNativeTestTableViewCell.h"
#import "MSPrerenderCell.h"
#import "MSNativeAdView.h"
#import "MSNativeVideoCell.h"
#import "MSNativeImageCell.h"
#import "FeedVideoView.h"

@interface MSNativeFeedAdViewController ()<MSNativeFeedAdDelegate,UITableViewDelegate,UITableViewDataSource,MSFeedVideoDelegate,MSNativeFeedAdExtensionFunctionDelegate>
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) UIButton *refreshBtn;
@property(nonatomic,strong) UIButton *muteBtn;
@property(nonatomic,strong) UIButton *playBtn;
@property(nonatomic,strong) UITableView *tableview;
@property(nonatomic,assign) CGRect adFrame;
@property(nonatomic,strong) UITextField *defaultPidTF;
@property(nonatomic,strong) MSNativeFeedAd *nativeExpressAd;
@property(nonatomic,strong) UITextField *widthTF;
@property(nonatomic,strong) UITextField *heightTF;
@property(nonatomic,strong) UITextField *nativeTF;

@end

@implementation MSNativeFeedAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    self.defaultPidTF.text = self.defaultPid;
    self.nativeTF = [MSQuickCreate defaultPidTextField];
    self.nativeTF.placeholder = @"调整logo位置，按照x,y,w,h格式输入";
    [self.view addSubview:self.nativeTF];
    [self.nativeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@48);
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.bottom.mas_equalTo(self.view).offset(-20);
    }];
    self.adType = MSAdTypeNativeExpressAd;
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets insets = self.view.safeAreaInsets;
        [self.tableview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.mas_equalTo(self.view).offset(insets.left);
            make.right.mas_equalTo(self.view).offset(-insets.right);
            make.bottom.equalTo(self.defaultPidTF.mas_top).offset(-20);
        }];
    } else {
        // Fallback on earlier versions
    }
}
- (void)refreshAd:(UIButton *)sender {
    [self loadNativeFeedAd];
}
-(void)loadNativeFeedAd{
    [self removeNativeFeedAds];
    NSString *pid = @"1061831";
    MSNativeFeedAdConfigParams *adParam = [[MSNativeFeedAdConfigParams alloc]init];
    adParam.adCount = 3;
    adParam.edgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    adParam.videoMuted = self.muteBtn.selected;
    adParam.imageHeight = 80;
    adParam.isAutoPlay = self.playBtn.selected;
    adParam.prerenderAdSize = CGSizeMake(self.widthTF.text.floatValue, self.heightTF.text.floatValue);
    self.nativeExpressAd = [[MSNativeFeedAd alloc]init];
    self.nativeExpressAd.delegate = self;
    self.nativeExpressAd.extDelegate = self;
    [self.nativeExpressAd loadAdWithPid:pid adParam:adParam];
    self.adFrame = CGRectZero;
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *view = [self.dataArray objectAtIndex:indexPath.row];
    if ([view isKindOfClass:[MSNativeTestModel class]]) {
        MSNativeTestModel *model = self.dataArray[indexPath.row];
        return [model cellHeight];
    //如果是自渲染图文广告
    }else if ([view isKindOfClass:[MSNativeAdView class]]){
        MSNativeAdType type = MSNativeAdLeftImage;
        MSNativeAdView *native = (MSNativeAdView *)view;
        id<MSFeedAdMeta>data1 = native.nativeFeedAdModel.adMaterialMeta;
        if (data1.metaCreativeType == MSCreativeTypeImage
            ||data1.metaCreativeType == MSCreativeTypeLargeImage) {
            type = MSNativeAdBottomImage;
        }else if(data1.metaCreativeType == MSCreativeTypeThreeImage){
            type = MSNativeAdThreeImage;
        }
        return [MSNativeAdView heightCellForRow:data1 nativeAdViewShowType:type];
    }else if([view isKindOfClass:[MSNativeFeedAdModel class]]){
        MSNativeFeedAdModel *feedModel = (MSNativeFeedAdModel *)view;
        return feedModel.feedView.bounds.size.height;
    }else if([view isKindOfClass:[FeedVideoView class]]){
        FeedVideoView *videoAd = (FeedVideoView *)view;
        return [FeedVideoView heightCellForRow:videoAd.nativeFeedAdModel.adMaterialMeta width:self.view.bounds.size.width];
    }
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *obj = self.dataArray[indexPath.row];
    if ([obj isKindOfClass:[MSNativeTestModel class]]) {
        MSNativeTestTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier: @"MSNativeTestCellIdentifier"];
        if (!cell) {
            cell = [[MSNativeTestTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MSNativeTestCellIdentifier"];
        }
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }else if([obj isKindOfClass:[MSNativeAdView class]]){
        MSNativeImageCell *imageCell = [tableView dequeueReusableCellWithIdentifier:@"nativeView"];
        if (!imageCell) {
            imageCell = [[MSNativeImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nativeView"];
        }
        return imageCell;
    }else if ([obj isKindOfClass:[MSNativeFeedAdModel class]]){
        MSNativeFeedAdModel *feed = (MSNativeFeedAdModel *)obj;
        MSPrerenderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSPrerenderCell"];
        if (!cell) {
            cell = [[MSPrerenderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MSPrerenderCell"];
        }
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UIView *adView = feed.feedView;
        CGRect frame = adView.frame;
        if (CGRectIsEmpty(self.adFrame)) {
            self.adFrame = CGRectMake(18, 0, frame.size.width-40, frame.size.height+200);
        }
        return cell;
    }else if ([obj isKindOfClass:[FeedVideoView class]]){
        MSNativeVideoCell *videoCell = [tableView dequeueReusableCellWithIdentifier:@"nativeVideo"];
        if (!videoCell) {
            videoCell = [[MSNativeVideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nativeVideo"];
        }
        return videoCell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *data = self.dataArray[indexPath.row];
    if ([cell isKindOfClass:[MSNativeImageCell class]]) {
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        MSNativeAdView *native = (MSNativeAdView *)data;
        [native unregisterDataObject];
        //绑定事件前传入
        [native.nativeFeedAdModel.adMaterialMeta setMetaLogoFrame:[self nativeAdParams]];
        [native registerDataObject];
        [cell.contentView addSubview:native];
    }else if ([cell isKindOfClass:[MSNativeVideoCell class]]){
        FeedVideoView *video = (FeedVideoView *)data;
        [video unregisterDataObject];
        MSNativeVideoCell *videoCell = (MSNativeVideoCell *)cell;
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        //绑定事件前传入
        [video.nativeFeedAdModel.adMaterialMeta setMetaLogoFrame:[self nativeAdParams]];
        video.isMute = self.muteBtn.selected;
        video.isAutoPlay = self.playBtn.selected;
        [video registerDataObject];
        [videoCell.contentView addSubview:video];
    }else if ([cell isKindOfClass:[MSNativeTestTableViewCell class]]){
        
    }else{
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        MSNativeFeedAdModel *viewData = (MSNativeFeedAdModel *)data;
        MSPrerenderCell *prerenderCell = (MSPrerenderCell *)cell;
        [prerenderCell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [viewData.feedView removeFromSuperview];
        viewData.presentVC = self;
        [prerenderCell.contentView addSubview:viewData.feedView];
        if (!viewData.isAdValid) {
            UILabel *toast = [[UILabel alloc]initWithFrame:cell.contentView.bounds];
            toast.text = @"广告已过期，请重新拉取广告";
            toast.textColor = [UIColor blueColor];
            [cell.contentView addSubview:toast];
            toast.textAlignment = NSTextAlignmentCenter;
        }
    }
}
- (void)removeNativeFeedAds{
    for (int index=0; index<self.dataArray.count; index++) {
        NSObject * obj = self.dataArray[index];
        if ([obj isKindOfClass:[FeedVideoView class]]) {
            FeedVideoView *video = (FeedVideoView *)obj;
            [video unregisterDataObject];
            [video removeFromSuperview];
        } else if ([obj isKindOfClass:[MSNativeFeedAdModel class]]){
            MSNativeFeedAdModel *model = (MSNativeFeedAdModel *)obj;
            if (model.isNativeExpress) {
                [model.feedView removeFromSuperview];
            }
        }  else if ([obj isKindOfClass:[MSNativeAdView class]]){
            MSNativeAdView *adView = (MSNativeAdView *)obj;
            [adView unregisterDataObject];
            [adView removeFromSuperview];
        }
    }
    [self.dataArray removeAllObjects];
    self.dataArray = nil;
    [self.tableview reloadData];
}
#pragma mark delegate
-(void)msNativeFeedAdLoaded:(MSNativeFeedAd *)nativeFeedAd feedAds:(NSArray<MSNativeFeedAdModel *> *)feedAds{
    [self showAlert:self.nativeExpressAd.mediaExt];
    //获取广告结果集合
    NSArray *nativeAdDataArray = feedAds;
    if (nativeAdDataArray.count > 0) {
        NSInteger count = nativeAdDataArray.count;
        NSInteger total = self.dataArray.count;
        for (int index=0; index<count; index++) {
            MSNativeFeedAdModel *obj = nativeAdDataArray[index];
            if (![obj isAdValid]) {
                continue;
            }
            NSInteger position = random()%total;
            //判断广告类型
            if (obj.isNativeExpress) {
                [self.dataArray insertObject:obj atIndex:position];
            }else{
                //如果是自渲染类型，转化成id<MSFeedAdMeta>类型读取广告信息
                id<MSFeedAdMeta> data = obj.adMaterialMeta;
                if (data.metaCreativeType != MSCreativeTypeVideo) {
                    //此处仅做调试用
                    CGSize size = [UIScreen mainScreen].bounds.size;
                    CGFloat width = size.width;
                    if (isMSIPhoneXSeries() && size.width > size.height) {
                        if (@available(iOS 11.0, *)) {
                            width = width - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right;
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    //以上调试结束
                    CGRect frame = CGRectMake(0, 0, width, 100);
                    MSNativeAdView *nativeAdView =[[MSNativeAdView alloc]initWithFrame:frame adPresentVc:self];
                    nativeAdView.nativeFeedAdModel = obj;
                    [self addDelegateString:[NSString stringWithFormat:@"物料平台===%ld",(long)data.metaPlatform]];
                    MSNativeAdType type = MSNativeAdLeftImage;
                    if (data.metaCreativeType == MSCreativeTypeImage
                        ||data.metaCreativeType == MSCreativeTypeLargeImage) {
                        type = MSNativeAdBottomImage;
                    }else if(data.metaCreativeType == MSCreativeTypeThreeImage){
                        type = MSNativeAdThreeImage;
                    }
                    nativeAdView.nativeAdViewShowType = type;
                    [self.dataArray insertObject:nativeAdView atIndex:position];
                }else{
                    FeedVideoView *video = [[FeedVideoView alloc]initWithWidth:self.view.bounds.size.width adPresentVc:self];
                    video.nativeFeedAdModel = obj;
                    [self.dataArray insertObject:video atIndex:position];
                    [self addDelegateString:[NSString stringWithFormat:@"物料平台===%ld",(long)data.metaPlatform]];
                }
            }
        }
    }
    [self.tableview reloadData];
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]加载成功%@",self.nativeExpressAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
}
-(void)msNativeFeedAdError:(MSNativeFeedAd *)nativeFeedAd withError:(NSError *)error{
    [self addDelegateString:[NSString stringWithFormat:@"广告拉取失败,错误：%@%@",error.localizedDescription,NSStringFromSelector(_cmd)]];
}
-(void)msNativeFeedAdMaterialMetaReadySuccess:(MSNativeFeedAd *)nativeFeedAd feedAd:(MSNativeFeedAdModel *)feedAd{
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]预处理成功%@",self.nativeExpressAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
    [self.tableview reloadData];
}
-(void)msNativeFeedAdMaterialMetaReadyError:(MSNativeFeedAd *)nativeFeedAd feedAd:(MSNativeFeedAdModel *)feedAd error:(NSError *)error{
    //如果素材预处理失败，从当前列表中移除
    for (int index=0; index<self.dataArray.count; index++) {
        NSObject *ad = self.dataArray[index];
        if ([ad isKindOfClass:[MSNativeFeedAdModel class]]) {
            if ([self.dataArray containsObject:feedAd]) {
                [feedAd.feedView removeFromSuperview];
                [self.dataArray removeObject:feedAd];
                [self.tableview reloadData];
                break;
            }
        } else if ([ad isKindOfClass:[UIView class]]){
            if ([ad isKindOfClass:[FeedVideoView class]]) {
                FeedVideoView *video = (FeedVideoView *)ad;
                if ([video.nativeFeedAdModel isEqual:feedAd]) {
                    [video unregisterDataObject];
                    [self.dataArray removeObject:video];
                    [self.tableview reloadData];
                    break;
                }
            } else if ([ad isKindOfClass:[MSNativeAdView class]]){
                MSNativeAdView *nativeAdView = (MSNativeAdView *)ad;
                if ([nativeAdView.nativeFeedAdModel isEqual:feedAd]) {
                    [nativeAdView unregisterDataObject];
                    [self.dataArray removeObject:nativeAdView];
                    [self.tableview reloadData];
                    break;
                }
            }
        }
    }
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]预处理失败,错误：%@%@",self.nativeExpressAd.mediaExt[kMSAdMediaAdnNameKey],error.localizedDescription,NSStringFromSelector(_cmd)]];
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
    if (feedAd.isNativeExpress) {
        [feedAd.feedView removeFromSuperview];
    }
    if ([self.dataArray containsObject:feedAd]) {
        [self.dataArray removeObject:feedAd];
    }
    [self.tableview reloadData];
    [self addDelegateString:[NSString stringWithFormat:@"[%@广告]模版广告已关闭%@",self.nativeExpressAd.mediaExt[kMSAdMediaAdnNameKey],NSStringFromSelector(_cmd)]];
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
#pragma mark - SetUpView
-(void)setUpView{
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    self.tableview = tableview;
    [self.view addSubview:self.tableview];
    self.defaultPidTF = [MSQuickCreate defaultPidTextField];
    [self.view addSubview:self.defaultPidTF];
    UIButton * loadBtn = [MSQuickCreate longActionBtn];
    [loadBtn setTitle:@"刷新广告" forState:UIControlStateNormal];
    [loadBtn addTarget:self
                action:@selector(refreshAd:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadBtn];
    [self.view addSubview:self.muteBtn];
    [self.view addSubview:self.playBtn];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.leading.trailing.offset(0);
        make.bottom.equalTo(self.defaultPidTF.mas_top).offset(-20);
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
        make.bottom.mas_equalTo(self.muteBtn.mas_top).offset(-20);
        make.top.equalTo(self.defaultPidTF.mas_bottom).offset(20);
    }];
    [self.muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(loadBtn);
        make.bottom.mas_equalTo(self.view).offset(-60);
    }];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.muteBtn.mas_right).offset(20);
        make.right.mas_equalTo(loadBtn.mas_right);
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
    }
    return _playBtn;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MSNativeResource.plist" ofType:nil];
        NSArray *datas = [[NSArray alloc]initWithContentsOfFile:path];
        for (int index=0; index<datas.count; index++) {
            MSNativeTestModel *model = [[MSNativeTestModel alloc]initWithDict:datas[index]];
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
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
-(void)dealloc{
    [MSLogger logString:[NSString stringWithFormat:@"%@-%@",NSStringFromClass(self.class),NSStringFromSelector(_cmd)] platform:-1];
}
@end
