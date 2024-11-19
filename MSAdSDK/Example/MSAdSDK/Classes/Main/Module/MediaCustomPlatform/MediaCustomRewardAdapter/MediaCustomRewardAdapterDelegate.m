//
//  MediaCustomRewardAdapterDelegate.m
//  MSAdSDKDev
//
//  Created by leej on 2022/5/17.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MediaCustomRewardAdapterDelegate.h"

@implementation MediaCustomRewardAdapterDelegate
/**
 This method is called when video ad material loaded successfully.
 */
- (void)nativeExpressRewardedVideoAdDidLoad:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    [self.event msCustomRewardVideoLoaded];
}

/**
 This method is called when video ad materia failed to load.
 @param error : the reason of error
 */
- (void)nativeExpressRewardedVideoAd:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error{
    [self.event msCustomRewardVideoError:error];
}
/**
  this methods is to tell delegate the type of native express rewarded video Ad
 */
// Mediation:/// @Note :  当加载聚合维度广告时，不支持该回调。
- (void)nativeExpressRewardedVideoAdCallback:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd withType:(BUNativeExpressRewardedVideoAdType)nativeExpressVideoType{
    
}

/**
 This method is called when cached successfully.
 For a better user experience, it is recommended to display video ads at this time.
 And you can call [BUNativeExpressRewardedVideoAd showAdFromRootViewController:].
 */
- (void)nativeExpressRewardedVideoAdDidDownLoadVideo:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    [self.event msCustomRewardVideoCached];
}

/**
 This method is called when rendering a nativeExpressAdView successed.
 It will happen when ad is show.
 */
// Mediation:/// @Note :  当加载聚合维度广告时，不支持该回调。
- (void)nativeExpressRewardedVideoAdViewRenderSuccess:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    
}

/**
 This method is called when a nativeExpressAdView failed to render.
 @param error : the reason of error
 */
// Mediation:/// @Note :  当加载聚合维度广告时，不支持该回调。
- (void)nativeExpressRewardedVideoAdViewRenderFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error{
    
}

/**
 This method is called when video ad slot will be showing.
 */
// Mediation:/// @Note :  当加载聚合维度广告时，支持该回调的adn有：CSJ
- (void)nativeExpressRewardedVideoAdWillVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    [self.event msCustomRewardVideoWillShow];
}

/**
 This method is called when video ad slot has been shown.
 */
- (void)nativeExpressRewardedVideoAdDidVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    
}

/**
 This method is called when video ad is about to close.
 */
// Mediation:/// @Note :  当加载聚合维度广告时，支持该回调的adn有：CSJ
- (void)nativeExpressRewardedVideoAdWillClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    
}

/**
 This method is called when video ad is closed.
 */
- (void)nativeExpressRewardedVideoAdDidClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    [self.event msCustomRewardVideoClosed];
}

/**
 This method is called when video ad is clicked.
 */
- (void)nativeExpressRewardedVideoAdDidClick:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    [self.event msCustomRewardVideoClicked];
}

/**
 This method is called when the user clicked skip button.
 */
- (void)nativeExpressRewardedVideoAdDidClickSkip:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd{
    [self.event msCustomRewardVideoClickSkipAndCurrentTime:0];
}

/**
 This method is called when video ad play completed or an error occurred.
 @param error : the reason of error
 */
- (void)nativeExpressRewardedVideoAdDidPlayFinish:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error{
    if (!error) {
        [self.event msCustomRewardVideoFinish];
    }else{
        [self.event msCustomRewardVideoPlayingError:error];
    }
}

/**
 Server verification which is requested asynchronously is succeeded. now include two v erify methods:
      1. C2C need  server verify  2. S2S don't need server verify
 @param verify :return YES when return value is 2000.
 */
- (void)nativeExpressRewardedVideoAdServerRewardDidSucceed:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify{
    [self.event msCustomRewardVideoReward:[NSString stringWithFormat:@"%ld",rewardedVideoAd.rewardedVideoModel.rewardAmount] rewardName:rewardedVideoAd.rewardedVideoModel.rewardName verify:verify?@"1":@"0"];
}

/**
  Server verification which is requested asynchronously is failed.
  @param rewardedVideoAd express rewardVideo Ad
  @param error request error info
 */
- (void)nativeExpressRewardedVideoAdServerRewardDidFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error{
    [self.event msCustomRewardVideoReward:[NSString stringWithFormat:@"%ld",rewardedVideoAd.rewardedVideoModel.rewardAmount] rewardName:rewardedVideoAd.rewardedVideoModel.rewardName verify:@"0"];
}
/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)nativeExpressRewardedVideoAdDidCloseOtherController:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd interactionType:(BUInteractionType)interactionType{
    
}
@end
