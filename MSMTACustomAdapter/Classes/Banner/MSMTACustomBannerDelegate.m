//
//  MSMTACustomBannerDelegate.m
//  MSMTACustomAdapter
//
//  Created by jdy on 2025/1/9.
//

#import "MSMTACustomBannerDelegate.h"

@interface MSMTACustomBannerDelegate ()
@property (nonatomic, assign) double ecpm;
@property (nonatomic, assign) BOOL isReady;

@end

@implementation MSMTACustomBannerDelegate

/// 广告策略服务加载成功
- (void)menta_didFinishLoadingBannerADPolicy:(MentaUnifiedBannerAd *_Nonnull)bannerAd {
    
}

/// 横幅(banner)广告源数据拉取成功
- (void)menta_bannerAdDidLoad:(MentaUnifiedBannerAd *_Nonnull)bannerAd {
    
}

/// 横幅(banner)广告物料下载成功
- (void)menta_bannerAdMaterialDidLoad:(MentaUnifiedBannerAd *_Nonnull)bannerAd {
    [self.event msCustomBannerLoaded:[bannerAd fetchBannerView]];
    [self.event msCustomBannerAdRenderSuccess:[bannerAd fetchBannerView]];
    [self.container addSubview:[bannerAd fetchBannerView]];
}

/// 横幅(banner)广告加载失败
- (void)menta_bannerAd:(MentaUnifiedBannerAd *_Nonnull)bannerAd didFailWithError:(NSError * _Nullable)error description:(NSDictionary *_Nonnull)description {
    [self.event msCustomBannerError:error];
}

/// 横幅(banner)广告被点击了
- (void)menta_bannerAdDidClick:(MentaUnifiedBannerAd *_Nonnull)bannerAd adView:(UIView *_Nullable)adView {
    [self.event msCustomBannerClicked:[bannerAd fetchBannerView]];
}

/// 横幅(banner)广告关闭了
- (void)menta_bannerAdDidClose:(MentaUnifiedBannerAd *_Nonnull)bannerAd adView:(UIView *_Nullable)adView {
    [self.event msCustomBannerClosed:[bannerAd fetchBannerView]];
}

/// 横幅(banner)将要展现
- (void)menta_bannerAdWillVisible:(MentaUnifiedBannerAd *_Nonnull)bannerAd adView:(UIView *_Nullable)adView {
    
}

/// 横幅(banner)广告曝光
- (void)menta_bannerAdDidExpose:(MentaUnifiedBannerAd *_Nonnull)bannerAd adView:(UIView *_Nullable)adView {
    [self.event msCustomBannerShow:[bannerAd fetchBannerView]];
}

/// 横幅(banner)广告 展现的广告信息 曝光之前会触发该回调
- (void)menta_bannerAd:(MentaUnifiedBannerAd *_Nonnull)bannerAd bestTargetSourcePlatformInfo:(NSDictionary *_Nonnull)info {
    NSLog(@"MS_MTA_TEST: %@", info);
    NSNumber *ecpm = info[@"BEST_SOURCE_PRICE"];
    self.ecpm = ecpm.doubleValue;
}

@end
