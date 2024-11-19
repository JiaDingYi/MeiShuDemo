//
//  MSBaseAdViewController.m
//  MSAdSDKDev
//
//  Created by Liumaos on 2020/7/17.
//  Copyright © 2020 XiXiHaha. All rights reserved.
//

#import "MSBaseAdViewController.h"
#import "MSDelegateViewController.h"
#import "MSTools.h"

@interface MSBaseAdViewController ()
@property(nonatomic,strong)NSMutableArray *delegateDataSource;
@end

@implementation MSBaseAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setTitle:@"查看回调" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItems = @[rightButton];
    [self adSupportMethods];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)adSupportMethods{
    NSMutableArray *tempArrM = nil;
    if (self.adType == MSAdTypeSplash) {
        tempArrM = [MSTools adSupportProtocol:@"MSSplashAdDelegate"];
        NSMutableArray *arr = [MSTools adSupportProtocol:@"MSSplashAdExtensionFuctionDelegate"];
        for (int index=0; index<arr.count; index++) {
            [tempArrM addObject:arr[index]];
        }
        NSMutableArray *arr1 = [MSTools adSupportProtocol:@"MSSplashZoomOutViewAdDelegate"];
        for (int index=0; index<arr1.count; index++) {
            [tempArrM addObject:arr1[index]];
        }
    }else if (self.adType == MSAdTypeReward){
        tempArrM = [MSTools adSupportProtocol:@"MSRewardVideoAdDelegate"];
        NSMutableArray *arr1 = [MSTools adSupportProtocol:@"MSRewardVideoAdExtensionFunctionDelegate"];
        for (int index=0; index<arr1.count; index++) {
            [tempArrM addObject:arr1[index]];
        }
    }else if (self.adType == MSAdTypeBanner){
        tempArrM = [MSTools adSupportProtocol:@"MSBannerViewDelegate"];
        NSMutableArray *arr1 = [MSTools adSupportProtocol:@"MSBannerViewExtensionFunctionDelegate"];
        for (int index=0; index<arr1.count; index++) {
            [tempArrM addObject:arr1[index]];
        }
    }else if (self.adType == MSAdTypeInterstitial){
        tempArrM = [MSTools adSupportProtocol:@"MSInterstitialDelegate"];
        NSMutableArray *arr1 = [MSTools adSupportProtocol:@"MSInterstitialExtensionFunctionDelegate"];
        for (int index=0; index<arr1.count; index++) {
            [tempArrM addObject:arr1[index]];
        }
    }else if (self.adType == MSAdTypePaster){
        tempArrM = [MSTools adSupportProtocol:@"MSVideoAdDelegate"];
        NSMutableArray *arr1 = [MSTools adSupportProtocol:@"MSVideoAdExtensionFunctionDelegate"];
        for (int index=0; index<arr1.count; index++) {
            [tempArrM addObject:arr1[index]];
        }
    }else if (self.adType == MSAdTypeFeed){
        tempArrM = [MSTools adSupportProtocol:@"MSNativeAdDelegate"];
        NSMutableArray *arr1 = [MSTools adSupportProtocol:@"MSNativeAdExtensionFunctionDelegate"];
        for (int index=0; index<arr1.count; index++) {
            [tempArrM addObject:arr1[index]];
        }
    }else if (self.adType == MSAdTypeFeedPreRender){
        tempArrM = [MSTools adSupportProtocol:@"MSPrerenderAdDelegate"];
        NSMutableArray *arr1 = [MSTools adSupportProtocol:@"MSPrerenderAdExtensionFunctionDelegate"];
        for (int index=0; index<arr1.count; index++) {
            [tempArrM addObject:arr1[index]];
        }
        [tempArrM removeObject:@"msPrerenderRenderSuccess:"];
    }else if (self.adType == MSAdTypeNativeExpressAd){
        tempArrM = [MSTools adSupportProtocol:@"MSNativeFeedAdDelegate"];
        NSMutableArray *finalArray = [[NSMutableArray alloc]init];
        for (NSString *str in tempArrM) {
            if ([str isEqualToString:@"msNativeFeedAdLoaded:"] ||
                [str isEqualToString:@"msNativeFeedAdError:"] ||
                [str isEqualToString:@"msNativeFeedAdPlatformError:error:"] ||
                [str isEqualToString:@"msNativeFeedAdMaterialMetaReadySuccess:"] ||
                [str isEqualToString:@"msNativeFeedAdMaterialMetaReadyError:error:"] ){
                continue;
            }
            [finalArray addObject:str];
        }
        tempArrM = finalArray;
        NSMutableArray *arr1 = [MSTools adSupportProtocol:@"MSNativeFeedAdExtensionFunctionDelegate"];
        for (int index=0; index<arr1.count; index++) {
            [tempArrM addObject:arr1[index]];
        }
    }else if (self.adType == MSAdTypeDraw){
        tempArrM = [MSTools adSupportProtocol:@"MSDrawAdDelegate"];
        NSMutableArray *arr1 = [MSTools adSupportProtocol:@"MSDrawAdExtensionFunctionDelegate"];
        for (int index=0; index<arr1.count; index++) {
            [tempArrM addObject:arr1[index]];
        }
        [tempArrM addObject:@"msDrawAdManagerLoadSuccess:"];
    }else if (self.adType == MSAdTypeFullScreenVideo){
        tempArrM = [MSTools adSupportProtocol:@"MSExpressFullScreenVideoAdDelegate"];
        NSMutableArray *arr1 = [MSTools adSupportProtocol:@"MSExpressFullScreenVideoAdExtensionFunctionDelegate"];
        for (int index=0; index<arr1.count; index++) {
            [tempArrM addObject:arr1[index]];
        }
    }
    for (NSString *str in tempArrM) {
        NSMutableDictionary *dictM = [[NSMutableDictionary alloc]init];
        [dictM setValue:str forKey:@"delegate"];
        [self.delegateDataSource addObject:dictM];
    }
}
-(void)rightBtnClick{
    if (self.delegateDataSource.count == 0) {
        [self adSupportMethods];
    }
    MSDelegateViewController *delegateVC = [[MSDelegateViewController alloc]init];
    delegateVC.dataSource = self.delegateDataSource;
    [self.navigationController pushViewController:delegateVC animated:YES];
}
- (void)addDelegateString:(NSString *)str{
    [MSLogger logString:str];
    if (self.delegateDataSource.count == 0) {
        [self adSupportMethods];
    }
    for (int index=0; index<self.delegateDataSource.count; index++) {
        NSMutableDictionary *dictM = self.delegateDataSource[index];
        NSString *protocoStr = [dictM objectForKey:@"delegate"];
        if ([str containsString:protocoStr]) {
            [dictM setValue:str forKey:@"delegate"];
            [dictM setValue:@"1" forKey:@"selected"];
            NSDate *date = [[NSDate alloc]init];
            [dictM setValue:[MSTools convertStrToTime:[NSString stringWithFormat:@"%lf",[date timeIntervalSince1970]]] forKey:@"time"];
        }
    }
}
-(void)showAlert:(NSDictionary *)alertDict{
    NSMutableString *alertSring = [[NSMutableString alloc]init];
    for (NSString *key in alertDict.allKeys) {
        [alertSring appendString:[NSString stringWithFormat:@"%@=%@\n",key,[alertDict objectForKey:key]]];
    }
    alertSring = alertSring.length > 0 ? alertSring : [[NSMutableString alloc]initWithString:@"暂无媒体信息"];
    CGSize size  = [MSTools getTextSize:alertSring fontSize:20 maxChatWidth:self.view.bounds.size.width/2];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/4, self.view.bounds.size.height/2-50, self.view.bounds.size.width/2, size.height)];
    [self.view addSubview:label];
    label.text = alertSring;
    label.numberOfLines=0;
    label.layer.cornerRadius=5;
    label.layer.masksToBounds=YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = [UIColor blackColor].CGColor;
    label.backgroundColor = [UIColor whiteColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [label removeFromSuperview];
    });
}
/**
 竞价成功上报
 */
-(void)sendWinNotificationWithInfo:(NSDictionary *)adInfo adLoader:(id)adLoader{
    NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]init];
    NSLog(@"美数竞价成功");
    [infoDict setValue:adInfo[kMSAdMediaAdnEcpmKey] forKey:kMSAdMediaWinPrice];
    //此处传入最大竞败方出价 单位：分
    [infoDict setValue:@"1.0" forKey:kMSAdMediaLossPrice];
    if ([adLoader respondsToSelector:@selector(sendWinNotificationWithInfo:)]) {
        [adLoader performSelector:@selector(sendWinNotificationWithInfo:) withObject:infoDict];
    }
}
-(void)sendLossNotificationWithInfo:(NSDictionary *)adInfo adLoader:(id)adLoader{
    NSLog(@"美数竞价失败");
    NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]init];
    [infoDict setValue:adInfo[kMSAdMediaAdnEcpmKey] forKey:kMSAdMediaWinPrice];
    [infoDict setValue:[NSString stringWithFormat:@"%ld",MSMediaLossReasonLowPrice] forKey:kMSAdMediaLossReason];
    [infoDict setValue:[NSString stringWithFormat:@"%ld",MSMediaWinADN_ThirdADN] forKey:kMSAdMediaWinADN];
    if ([adLoader respondsToSelector:@selector(sendLossNotificationWithInfo:)]) {
        [adLoader performSelector:@selector(sendLossNotificationWithInfo:) withObject:infoDict];
    }
}
-(NSMutableArray *)delegateDataSource{
    if (!_delegateDataSource) {
        _delegateDataSource = [[NSMutableArray alloc]init];
    }
    return _delegateDataSource;
}
@end
