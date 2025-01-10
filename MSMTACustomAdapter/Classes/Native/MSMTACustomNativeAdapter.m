//
//  MSMTACustomNativeAdapter.m
//  IQKeyboardManager
//
//  Created by jdy on 2025/1/8.
//

#import "MSMTACustomNativeAdapter.h"
#import <MentaUnifiedSDK/MentaUnifiedSDK-umbrella.h>
#import "MSMTACustomNativeDelegate.h"
#import <MSAdSDK/MSAdSDK.h>

@interface MSMTACustomNativeAdapter () <MSCustomNativeAdapterProtocol>
@property(nonatomic,strong) MentaUnifiedNativeAd *manager;
@property(nonatomic,strong) MSMTACustomNativeDelegate *reporter;

@end

@implementation MSMTACustomNativeAdapter

/**
 *  加载广告
 *  详解：pid - 广告位 id
 */
- (void)loadAdPid:(NSString *)pid
          adCount:(NSInteger)adCount
        presentVC:(UIViewController *)presentVC
            event:(id<MSCustomNativeEventProtocol>)event {
    self.reporter.event = event;
    self.reporter.presentVC = presentVC;
    MUNativeConfig *config = [MUNativeConfig new];
    config.slotId = pid;
    config.viewController = presentVC;
    config.tolerateTime = 5;
    self.manager = [[MentaUnifiedNativeAd alloc] initWithConfig:config];
    self.manager.delegate = self.reporter;
    [self.manager loadAd];
}

//更新vc
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
    self.reporter = [[MSMTACustomNativeDelegate alloc] init];
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
    
}

@end
