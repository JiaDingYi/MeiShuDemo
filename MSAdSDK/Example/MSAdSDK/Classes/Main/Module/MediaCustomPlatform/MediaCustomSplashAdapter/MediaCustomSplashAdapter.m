//
//  MediaCustomSplashAdapter.m
//  MSAdSDKDev
//
//  Created by leej on 2022/4/26.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MediaCustomSplashAdapter.h"
#import "MediaCustomSplashDelegate.h"
#import "MediaSDKManager.h"
#import <BUAdSDK/BUAdSDK.h>

@interface MediaCustomSplashAdapter ()
@property(nonatomic,strong)BUSplashAd *splash;
@property(nonatomic,assign)CGSize bottomSize;
@property(nonatomic,strong)MSMediaInfoModel *model;
@property(nonatomic,strong)MediaCustomSplashDelegate *splashDelegate;
@end

@implementation MediaCustomSplashAdapter
#pragma mark 初始化sdk
-(void)registSdkWithInfo:(NSDictionary *)info{
    self.model = [[MSMediaInfoModel alloc]initWithDict:info];
    if (![[MediaSDKManager shareSdkManager] registThirdSdkAppid:self.model.appid]) {
        BUAdSDKConfiguration *configuration = [BUAdSDKConfiguration configuration];
        if ([configuration respondsToSelector:@selector(setTerritory:)]) {
#if kCan_BUSDKInterface
        configuration.territory = BUAdSDKTerritory_CN;
#endif
        }
        configuration.appID = self.model.appid;
    }
    self.splashDelegate = [[MediaCustomSplashDelegate alloc]init];
}
#pragma mark 加载广告
-(void)loadSplashAd:(NSString *)pid splashEvent:(id<MSCustomSplashEventProtocol>)event{
    if (!self.splash) {
        CGSize adSize = [UIScreen mainScreen].bounds.size;
        adSize.height =  adSize.height - self.bottomSize.height;
        self.splash = [[BUSplashAd alloc]initWithSlotID:pid adSize:adSize];
    }
    self.splash.supportZoomOutView = YES;
    self.splash.zoomOutDelegate = self.splashDelegate;
    self.splash.delegate = self.splashDelegate;
    self.splashDelegate.reporter = event;
    if ([BUAdSDKManager initializationState] == BUAdSDKInitializationStateReady) {
        [self.splash loadAdData];
    } else {
        [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.splash loadAdData];
                });
            }
        }];
    }
}
#pragma mark 展示广告
-(void)showSplashAd:(UIWindow *)window bottomView:(UIView *)bottomView{
    if (bottomView) {
        CGSize adSize = [UIScreen mainScreen].bounds.size;
        bottomView.frame = CGRectMake(0, adSize.height - self.bottomSize.height, self.bottomSize.width, self.bottomSize.height);
        [window addSubview:bottomView];
    }
    [self.splash showSplashViewInRootViewController:window.rootViewController];
}
#pragma mark 获取三方报价
-(NSInteger)adapterEcpm{
    return 0;
}
#pragma mark 获取广告是否有效
-(BOOL)isAdValid{
    return YES;
}
#pragma mark 获取广告参数
-(void)configMediaParamsOnPlatform:(NSDictionary *)mediaParams{
    if ([mediaParams.allKeys containsObject:@"bottomSize"]) {
        self.bottomSize = [[mediaParams valueForKey:@"bottomSize"] CGSizeValue];
    }
}
#pragma mark 获取点睛
-(UIView *)splashZoomView{
    return self.splash.zoomOutView;
}
@end
