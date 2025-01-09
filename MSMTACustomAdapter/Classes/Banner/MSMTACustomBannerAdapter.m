//
//  MSMTACustomBannerAdapter.m
//  IQKeyboardManager
//
//  Created by jdy on 2025/1/8.
//

#import "MSMTACustomBannerAdapter.h"
#import "MSMTACustomBannerDelegate.h"
#import <MentaUnifiedSDK/MentaUnifiedSDK-umbrella.h>

@interface MSMTACustomBannerAdapter ()
@property (nonatomic, strong) MentaUnifiedBannerAd *banner;
@property (nonatomic, strong) MSMTACustomBannerDelegate *reporter;
@property (nonatomic, strong) UIView *container;

@end

@implementation MSMTACustomBannerAdapter

/**
 *  加载广告
 *  详解：pid - 广告位 id
 */
- (UIView *)loadAndShow:(NSString *)pid
              presentVC:(UIViewController *)presentVC
                 adSize:(CGSize)adSize
            bannerEvent:(id<MSCustomBannerEventProtocol>)event {
    MUBannerConfig *config = [[MUBannerConfig alloc] init];
    config.adSize = adSize;
    config.slotId = pid;
    config.materialFillMode = MentaBannerAdMaterialFillMode_ScaleAspectFill;
    config.viewController = presentVC;
    self.banner = [[MentaUnifiedBannerAd alloc] initWithConfig:config];
    self.banner.delegate = self.reporter;
    self.reporter.event = event;
    
    [self.banner loadAd];
    self.container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, adSize.width, adSize.height)];
    self.reporter.container = self.container;
    return self.container;
}

- (void)updateCustomAdapterCurrentPresentVC:(UIViewController *)presentVC {
    
}

/**
 注册获取初始化sdk相关参数
 */
- (void)registSdkWithInfo:(NSDictionary *)info {
    NSLog(@"MS_MTA_TEST: %@", info);
    NSString *appID = info[@"mta_app_id"];
    NSString *appKey = info[@"mta_app_key"];
    if (!appID || !appKey) {
        NSLog(@"MS_MTA_TEST: empty info");
        return;
    }
    self.reporter = [[MSMTACustomBannerDelegate alloc] init];
    [MUAPI startWithAppID:appID appKey:appKey finishBlock:^(BOOL success, NSError * _Nullable error) {
        
    }];
}

/**
 获取ecpm
 注意：如获取不到，请传0
 */
- (NSInteger)adapterEcpm {
    return self.reporter.ecpm;
}
/**
 获取MS平台上配置的个性化参数
 */
- (void)configMediaParamsOnPlatform:(NSDictionary *)mediaParams {
    
}
//发送竞胜结果
- (void)sendWinNotification:(NSInteger)price {
    [self.banner sendWinNotification];
}
//发送竞胜结果及竞价失败的媒体最高价
- (void)sendWinNotification:(NSInteger)price otherHighestPrice:(NSInteger)highestPrice {
    
}
/**
 发送竞败结果
 @param price 当前竞价胜出的价格
 @param reason 竞价失败原因
 @param adnId 当前竞价胜出平台渠道ID
 */
- (void)sendLossNotification:(NSInteger)price reason:(MSAdBiddingErrorType)reason adnId:(NSString *)adnId {
    [self.banner sendLossNotificationWithInfo:@{@"winPrice": [NSNumber numberWithInteger:price]}];
}

@end
