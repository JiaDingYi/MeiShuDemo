//
//  MSMTACustomInterstitialDelegate.m
//  MSMTACustomAdapter
//
//  Created by jdy on 2025/1/9.
//

#import "MSMTACustomInterstitialDelegate.h"

@interface MSMTACustomInterstitialDelegate ()

@property (nonatomic, assign) double ecpm;
@property (nonatomic, assign) BOOL isReady;

@end

@implementation MSMTACustomInterstitialDelegate

/// 广告策略服务加载成功
- (void)menta_didFinishLoadingInterstitialADPolicy:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd {
    
}

/// 插屏广告源数据拉取成功
- (void)menta_interstitialAdDidLoad:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd {
    self.isReady = YES;
    [self.event msCustomInterstitialEventLoaded];
}

/// 插屏广告视频下载成功
- (void)menta_interstitialAdMaterialDidLoad:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd {
    self.isReady = YES;
    [self.event msCustomInterstitialEventRenderSuccess];
}

/// 插屏广告加载失败
- (void)menta_interstitialAd:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd didFailWithError:(NSError * _Nullable)error description:(NSDictionary *_Nonnull)description {
    self.isReady = NO;
    [self.event msCustomInterstitialEventError:error];
}

/// 插屏广告被点击了
- (void)menta_interstitialAdDidClick:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd {
    [self.event msCustomInterstitialEventClicked];
}

/// 插屏广告关闭了
- (void)menta_interstitialAdDidClose:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd {
    [self.event msCustomInterstitialEventClosed];
}

/// 插屏将要展现
- (void)menta_interstitialAdWillVisible:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd {
    
}

/// 插屏广告曝光
- (void)menta_interstitialAdDidExpose:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd {
    [self.event msCustomInterstitialEventShow];
}

/// 插屏广告 展现的广告信息 曝光之前会触发该回调
- (void)menta_interstitialAd:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd bestTargetSourcePlatformInfo:(NSDictionary *_Nonnull)info {
    NSLog(@"MS_MTA_TEST: %@", info);
    NSNumber *ecpm = info[@"BEST_SOURCE_PRICE"];
    self.ecpm = ecpm.doubleValue;
}

@end
