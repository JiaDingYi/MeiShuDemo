//
//  MediaCustomFullScreenVideoAdapter.m
//  MSAdSDKDev
//
//  Created by leej on 2022/5/19.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MediaCustomFullScreenVideoAdapter.h"
#import "MediaSDKManager.h"
#import <BUAdSDK/BUAdSDK.h>
#import <MSAdSDK/MSCustomFullScreenVideoEventProtocol.h>
#import "MediaCustomFullScreenVideoAdapterDelegate.h"

@interface MediaCustomFullScreenVideoAdapter ()
@property(nonatomic,strong)MSMediaInfoModel *model;
@property(nonatomic,strong)BUNativeExpressFullscreenVideoAd *video;
@property(nonatomic,strong)MediaCustomFullScreenVideoAdapterDelegate *reporter;
@end

@implementation MediaCustomFullScreenVideoAdapter

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
    self.reporter = [[MediaCustomFullScreenVideoAdapterDelegate alloc]init];
}
-(void)loadAd:(NSString *)pid videoEvent:(id<MSCustomFullScreenVideoEventProtocol>)event{
    self.reporter.event = event;
    self.video = [[BUNativeExpressFullscreenVideoAd alloc]initWithSlotID:pid];
    self.video.delegate = self.reporter;
    if ([BUAdSDKManager initializationState] == BUAdSDKInitializationStateReady) {
        [self.video loadAdData];
    } else {
        [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.video loadAdData];
                });
            }
        }];
    }
}
-(void)showAdFromVC:(UIViewController *)rootVC{
    [self.video showAdFromRootViewController:rootVC];
}
-(BOOL)isAdValid{
    return self.reporter.isAdValid;
}
-(NSInteger)adapterEcpm{
    return 0;
}
@end
