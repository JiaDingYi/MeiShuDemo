//
//  MediaCustomInterstitialAdapter.m
//  MSAdSDKDev
//
//  Created by leej on 2022/5/16.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MediaCustomInterstitialAdapter.h"
#import "MediaCustomInterstitialDelegate.h"
#import "MediaSDKManager.h"
#import <BUAdSDK/BUAdSDK.h>

@interface MediaCustomInterstitialAdapter ()
@property(nonatomic,strong)MSMediaInfoModel *model;
@property(nonatomic,strong)BUNativeExpressFullscreenVideoAd *interstitialAd;
@property(nonatomic,strong)MediaCustomInterstitialDelegate *reporter;
@end

@implementation MediaCustomInterstitialAdapter

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
    self.reporter = [[MediaCustomInterstitialDelegate alloc]init];
}
-(void)loadAd:(NSString *)pid interstitialEvent:(id<MSCustomInterstitialEventProtocol>)event{
    BUAdSlot *slot = [[BUAdSlot alloc]init];
    slot.AdType = BUAdSlotAdTypeFullscreenVideo;
    slot.ID = pid;
    BUSize *size = [[BUSize alloc]init];
    size.width = 300;
    size.height = 450;
    slot.imgSize = size;
    slot.position = BUAdSlotPositionTop;
    self.interstitialAd = [[BUNativeExpressFullscreenVideoAd alloc]initWithSlot:slot];
    self.interstitialAd.delegate = self.reporter;
    self.reporter.event = event;
    if ([BUAdSDKManager initializationState] == BUAdSDKInitializationStateReady) {
        [self.interstitialAd loadAdData];
    } else {
        [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.interstitialAd loadAdData];
                });
            }
        }];
    }
}
-(void)showAdFromVC:(UIViewController *)rootVC{
    [self.interstitialAd showAdFromRootViewController:rootVC];
}
-(NSInteger)adapterEcpm{
    return 0;
}
-(BOOL)isAdValid{
    return YES;
}
@end
