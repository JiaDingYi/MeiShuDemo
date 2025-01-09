//
//  MSMTACustomInterstitialAdapter.m
//  IQKeyboardManager
//
//  Created by jdy on 2025/1/8.
//

#import "MSMTACustomInterstitialAdapter.h"
#import "MSMTACustomInterstitialDelegate.h"
#import <MentaUnifiedSDK/MentaUnifiedSDK-umbrella.h>

@interface MSMTACustomInterstitialAdapter ()
@property(nonatomic,strong) MentaUnifiedInterstitialAd *interstitialAd;
@property(nonatomic,strong) MSMTACustomInterstitialDelegate *reporter;

@end

@implementation MSMTACustomInterstitialAdapter

/**
 *  加载广告
 *  详解：pid - 广告位 id
 */
- (void)loadAd:(NSString *)pid interstitialEvent:(id<MSCustomInterstitialEventProtocol>)event {
    MUInterstitialConfig *config = [[MUInterstitialConfig alloc] init];
    config.adSize = UIScreen.mainScreen.bounds.size;
    config.slotId = pid;
    self.interstitialAd = [[MentaUnifiedInterstitialAd alloc] initWithConfig:config];
    self.interstitialAd.delegate = self.reporter;
    [self.interstitialAd loadAd];
    self.reporter.event = event;
}
/**
 *  显示广告
 *  详解：显示广告
 */
- (void)showAdFromVC:(UIViewController *)rootVC {
    [self.interstitialAd showAdFromViewController:rootVC];
}
/**
 广告是否有效
 如果三方提供查询广告是否有效接口则用三方的，否则按照三方广告过期时长进行处理
 */
- (BOOL)isAdValid {
    return self.reporter.isReady;
}

//释放广告资源
- (void)destoryInterstitialAd {
    
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
    self.reporter = [[MSMTACustomInterstitialDelegate alloc] init];
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
    [self.interstitialAd sendWinNotification];
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
    [self.interstitialAd sendLossNotificationWithInfo:@{@"winPrice": [NSNumber numberWithInteger:price]}];
}

@end
