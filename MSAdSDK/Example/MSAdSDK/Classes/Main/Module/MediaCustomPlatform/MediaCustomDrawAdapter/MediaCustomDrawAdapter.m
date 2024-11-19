//
//  MediaCustomDrawAdapter.m
//  MSAdSDKDev
//
//  Created by leej on 2022/5/19.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MediaCustomDrawAdapter.h"
#import "MediaSDKManager.h"
#import <BUAdSDK/BUAdSDK.h>
#import "MediaCustomDrawAdapterDelegate.h"
#import <MSAdSDK/MSCustomDrawEventProtocol.h>

@interface MediaCustomDrawAdapter ()
@property(nonatomic,strong)MSMediaInfoModel *model;
@property(nonatomic,strong)BUNativeExpressAdManager *manager;
@property(nonatomic,strong)BUNativeExpressAdView *buAdView;
@property(nonatomic,strong)MediaCustomDrawAdapterDelegate *reporter;
@end

@implementation MediaCustomDrawAdapter

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
    self.reporter = [[MediaCustomDrawAdapterDelegate alloc]init];
}
-(void)loadAdPid:(NSString *)pid
       presentVC:(UIViewController *)presentVC
          adSize:(CGSize)adSize
      videoEvent:(id<MSCustomDrawEventProtocol>)event{
    self.reporter.event = event;
    BUAdSlot *slot = [[BUAdSlot alloc]init];
    BUSize *size = [BUSize sizeBy:BUProposalSize_DrawFullScreen];
    [slot setID:pid];
    if ([slot respondsToSelector:@selector(setIsOriginAd:)]) {
#if kCan_BUSDKInterface
        [slot setIsOriginAd:YES];
#endif
    }
    [slot setAdType:BUAdSlotAdTypeDrawVideo];
    [slot setImgSize:size];
    [slot setPosition:BUAdSlotPositionTop];
    self.manager = [[BUNativeExpressAdManager alloc]initWithSlot:slot adSize:adSize];
    self.manager.delegate = self.reporter;
    if ([BUAdSDKManager initializationState] == BUAdSDKInitializationStateReady) {
        [self.manager loadAdDataWithCount:1];
    } else {
        [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.manager loadAdDataWithCount:1];
                });
            }
        }];
    }
    __weak typeof(self)weakSelf = self;
    __weak UIViewController *weakVC = presentVC;
    self.reporter.successblock = ^(UIView * _Nonnull adView) {
        weakSelf.buAdView = (BUNativeExpressAdView *)adView;
        weakSelf.buAdView.rootViewController = weakVC;
        [weakSelf.buAdView render];
    };
}
-(void)showAdViewInContainer:(UIView *)container{
    [container addSubview:self.buAdView];
}
-(void)dismissDrawAdView{
    [self.buAdView removeFromSuperview];
}
-(void)play{
    
}
-(void)pause{
    
}
-(void)stop{
    [self.buAdView removeFromSuperview];
    self.buAdView = nil;
    self.manager = nil;
}
-(void)setVideoMute:(BOOL)mute{
    
}
-(NSTimeInterval)currentTime{
    return [self.buAdView currentPlayedTime];
}
-(NSTimeInterval)duration{
    return self.buAdView.videoDuration;
}
-(NSInteger)adapterEcpm{
    return 0;
}
@end
