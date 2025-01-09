//
//  MSMTACustomSplashDelegate.m
//  MSMTACustomAdapter
//
//  Created by jdy on 2025/1/9.
//

#import "MSMTACustomSplashDelegate.h"

@interface MSMTACustomSplashDelegate ()

@property (nonatomic, assign) double ecpm;
@property (nonatomic, assign) BOOL isReady;

@end

@implementation MSMTACustomSplashDelegate

/// 广告策略服务加载成功
- (void)menta_didFinishLoadingADPolicy:(MentaUnifiedSplashAd *_Nonnull)splashAd {
    
}

/// 开屏广告数据拉取成功
- (void)menta_splashAdDidLoad:(MentaUnifiedSplashAd *_Nonnull)splashAd {
    [self.reporter msCustomSplashEventSplashLoaded];
    [self.reporter msCustomSplashEventRenderSuccess];
    self.isReady = YES;
}


/// 开屏加载失败
- (void)menta_splashAd:(MentaUnifiedSplashAd *_Nonnull)splashAd didFailWithError:(NSError * _Nullable)error description:(NSDictionary *_Nonnull)description {
    [self.reporter msCustomSplashEventError:error];
    self.isReady = NO;
}

/// 开屏广告被点击了
- (void)menta_splashAdDidClick:(MentaUnifiedSplashAd *_Nonnull)splashAd {
    [self.reporter msCustomSplashEventSplashClicked];
}

/// 开屏广告关闭了
- (void)menta_splashAdDidClose:(MentaUnifiedSplashAd *_Nonnull)splashAd closeMode:(MentaSplashAdCloseMode)mode {
    [self.reporter msCustomSplashEventSplashWillClosed];
    [self.reporter msCustomSplashEventSplashClosed];
}

/// 开屏广告曝光
- (void)menta_splashAdDidExpose:(MentaUnifiedSplashAd *_Nonnull)splashAd {
    [self.reporter msCustomSplashEventSplashShow];
}

/// 开屏广告 展现的广告信息 曝光之前会触发该回调
- (void)menta_splashAd:(MentaUnifiedSplashAd *_Nonnull)splashAd bestTargetSourcePlatformInfo:(NSDictionary *_Nonnull)info {
    NSLog(@"MS_MTA_TEST: %@", info);
    NSNumber *ecpm = info[@"BEST_SOURCE_PRICE"];
    self.ecpm = ecpm.doubleValue;
}

@end
