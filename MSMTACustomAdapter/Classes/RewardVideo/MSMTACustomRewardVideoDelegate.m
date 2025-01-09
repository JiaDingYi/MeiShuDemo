//
//  MSMTACustomRewardVideoDelegate.m
//  MSMTACustomAdapter
//
//  Created by jdy on 2025/1/9.
//

#import "MSMTACustomRewardVideoDelegate.h"

@interface MSMTACustomRewardVideoDelegate ()
@property (nonatomic, assign) double ecpm;

@end

@implementation MSMTACustomRewardVideoDelegate

/// 广告策略服务加载成功
- (void)menta_didFinishLoadingRewardVideoADPolicy:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    
}

/// 激励视频广告源数据拉取成功
- (void)menta_rewardVideoAdDidLoad:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    [self.event msCustomRewardVideoLoaded];
}

/// 激励视频广告视频下载成功
- (void)menta_rewardVideoAdMaterialDidLoad:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    [self.event msCustomRewardVideoCached];
}

/// 激励视频加载失败
- (void)menta_rewardVideoAd:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd didFailWithError:(NSError * _Nullable)error description:(NSDictionary *_Nonnull)description {
    [self.event msCustomRewardVideoError:error];
}

/// 激励视频广告被点击了
- (void)menta_rewardVideoAdDidClick:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    [self.event msCustomRewardVideoClicked];
}

/// 激励视频广告关闭了
- (void)menta_rewardVideoAdDidClose:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd closeMode:(MentaRewardVideoAdCloseMode)mode {
    [self.event msCustomRewardVideoClosed];
}

/// 激励视频将要展现
- (void)menta_rewardVideoAdWillVisible:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    [self.event msCustomRewardVideoWillShow];
}

/// 激励视频广告曝光
- (void)menta_rewardVideoAdDidExpose:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    
}

/// 激励视频广告播放达到激励条件回调
- (void)menta_rewardVideoAdDidRewardEffective:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    [self.event msCustomRewardVideoReward:@"1" rewardName:@"" verify:@"1"];
}

/// 激励视频广告播放完成回调
- (void)menta_rewardVideoAdDidPlayFinish:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    [self.event msCustomRewardVideoFinish];
}

/// 激励视频广告 展现的广告信息 曝光之前会触发该回调
- (void)menta_rewardVideoAd:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd bestTargetSourcePlatformInfo:(NSDictionary *_Nonnull)info {
    NSLog(@"MS_MTA_TEST: %@", info);
    NSNumber *ecpm = info[@"BEST_SOURCE_PRICE"];
    self.ecpm = ecpm.doubleValue;
}


@end
