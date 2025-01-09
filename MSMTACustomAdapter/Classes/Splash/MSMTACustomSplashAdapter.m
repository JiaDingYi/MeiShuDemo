//
//  MSMTACustomSplashAdapter.m
//  IQKeyboardManager
//
//  Created by jdy on 2025/1/8.
//

#import "MSMTACustomSplashAdapter.h"
#import "MSMTACustomSplashDelegate.h"
#import <MentaUnifiedSDK/MentaUnifiedSDK-umbrella.h>

@interface MSMTACustomSplashAdapter ()

@property (nonatomic, strong) MentaUnifiedSplashAd *splash;
@property (nonatomic, assign) CGSize bottomSize;
@property (nonatomic, strong) UIView *splashBottom;
@property (nonatomic, strong) MSMTACustomSplashDelegate *splashDelegate;

@end

@implementation MSMTACustomSplashAdapter

/**
 加载广告
 */
- (void)loadSplashAd:(NSString *)pid
         splashEvent:(id<MSCustomSplashEventProtocol>)event {
    if (!self.splash) {
        CGSize adSize = [UIScreen mainScreen].bounds.size;
        adSize.height =  adSize.height - self.bottomSize.height;
        MUSplashConfig *config = [MUSplashConfig new];
        config.slotId = pid;
        config.tolerateTime = 5;
//        config.viewController = self;
        config.bottomView = self.splashBottom;
        config.adSize = adSize;
        self.splash = [[MentaUnifiedSplashAd alloc] initWithConfig:config];
    }
    self.splash.delegate = self.splashDelegate;
    self.splashDelegate.reporter = event;
    [self.splash loadAd];
}
/**
 展示开屏广告
 */
- (void)showSplashAd:(UIWindow *)window bottomView:(UIView *)bottomView {
    if (bottomView && self.splashBottom) {
        [self.splashBottom addSubview:bottomView];
    }
    [self.splash showInWindow:window];
}
/**
 广告是否有效
 如果三方提供查询广告是否有效接口则用三方的，否则按照三方广告过期时长进行处理
 */
- (BOOL)isAdValid {
    return self.splashDelegate.isReady;
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
    self.splashDelegate = [[MSMTACustomSplashDelegate alloc] init];
    [MUAPI startWithAppID:appID appKey:appKey finishBlock:^(BOOL success, NSError * _Nullable error) {
        
    }];
}

/**
 获取ecpm
 注意：如获取不到，请传0
 */
- (NSInteger)adapterEcpm {
    return 0;
}
/**
 获取MS平台上配置的个性化参数
 */
- (void)configMediaParamsOnPlatform:(NSDictionary *)mediaParams {
    self.bottomSize = [[mediaParams valueForKey:@"bottomSize"] CGSizeValue];
        //不存在bottom view
        if (CGSizeEqualToSize(self.bottomSize, CGSizeZero)) {
            
        } else {
            //存在bottom view
            //新建一个bottom view 容器
            self.splashBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bottomSize.width, self.bottomSize.height)];
        }
}
//发送竞胜结果
- (void)sendWinNotification:(NSInteger)price {
    [self.splash sendLossNotificationWithInfo:@{@"winPrice": [NSNumber numberWithInteger:price]}];
}
//发送竞胜结果及竞价失败的媒体最高价
- (void)sendWinNotification:(NSInteger)price otherHighestPrice:(NSInteger)highestPrice {
    [self.splash sendWinNotification];
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
