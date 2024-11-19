//
//  MediaCustomFullScreenVideoAdapterDelegate.m
//  MSAdSDKDev
//
//  Created by leej on 2022/5/19.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MediaCustomFullScreenVideoAdapterDelegate.h"

@implementation MediaCustomFullScreenVideoAdapterDelegate

-(void)nativeExpressFullscreenVideoAdDidLoad:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    [self.event msCustomFullScreenVideoAdLoadSuccess];
}
-(void)nativeExpressFullscreenVideoAdDidClick:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    [self.event msCustomFullScreenVideoAdDidClick:nil withPlayingProgress:0];
}
-(void)nativeExpressFullscreenVideoAdDidClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    [self.event msCustomFullScreenVideoAdDidCloseWithPlayingProgress:0];
}
-(void)nativeExpressFullscreenVideoAdWillClose:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    
}
-(void)nativeExpressFullscreenVideoAdDidVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    [self.event msCustomFullScreenVideoAdShowSuccess:nil];
}
-(void)nativeExpressFullscreenVideoAdWillVisible:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    
}
-(void)nativeExpressFullscreenVideoAdDidClickSkip:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    [self.event msCustomFullScreenVideoAdDidSkipWithPlayingProgress:0];
}
-(void)nativeExpressFullscreenVideoAdViewRenderSuccess:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd{
    
}
-(void)nativeExpressFullscreenVideoAdDidDownLoadVideo:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd{
    self.isAdValid = YES;
    [self.event msCustomFullScreenVideoAdCacheSuccess];
}
-(void)nativeExpressFullscreenVideoAdCallback:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd withType:(BUNativeExpressFullScreenAdType)nativeExpressVideoAdType{
    
}
-(void)nativeExpressFullscreenVideoAd:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *)error{
    [self.event msCustomFullScreenVideoAdLoadFail:error];
}
-(void)nativeExpressFullscreenVideoAdViewRenderFail:(BUNativeExpressFullscreenVideoAd *)rewardedVideoAd error:(NSError *)error{
    [self.event msCustomFullScreenVideoAdShowFailed:error];
}
-(void)nativeExpressFullscreenVideoAdDidPlayFinish:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *)error{
    [self.event msCustomFullScreenVideoAdDidPlayFinish:error];
}
-(void)nativeExpressFullscreenVideoAdDidCloseOtherController:(BUNativeExpressFullscreenVideoAd *)fullscreenVideoAd interactionType:(BUInteractionType)interactionType{
    
}
@end
