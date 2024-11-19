//
//  MediaCustomBannerAdapter.m
//  MSAdSDKDev
//
//  Created by leej on 2022/5/17.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MediaCustomBannerAdapter.h"
#import "MediaCustomBannerAdapterDelegate.h"
#import "MediaSDKManager.h"
#import <BUAdSDK/BUAdSDK.h>

@interface MediaCustomBannerAdapter ()
@property(nonatomic,strong)MSMediaInfoModel *model;
@property(nonatomic,strong)BUNativeExpressBannerView *banner;
@property(nonatomic,strong)MediaCustomBannerAdapterDelegate *reporter;
@end

@implementation MediaCustomBannerAdapter

-(void)registSdkWithInfo:(NSDictionary *)info{
    self.model = [[MSMediaInfoModel alloc]initWithDict:info];
    if (![[MediaSDKManager shareSdkManager] registThirdSdkAppid:self.model.appid]) {
        BUAdSDKConfiguration *configuration = [BUAdSDKConfiguration configuration];
        if ([configuration respondsToSelector:@selector(setTerritory:)]) {
#if kCan_BUSDKInterface
        configuration.territory = BUAdSDKTerritory_CN;
#endif
        }
        configuration.appID = self.model.appid;
    }
    self.reporter = [[MediaCustomBannerAdapterDelegate alloc]init];
}
-(UIView *)loadAndShow:(NSString *)pid
             presentVC:(UIViewController *)presentVC
                adSize:(CGSize)adSize
           bannerEvent:(nonnull id<MSCustomBannerEventProtocol>)event{
    self.banner = [[BUNativeExpressBannerView alloc]initWithSlotID:pid rootViewController:presentVC adSize:adSize];
    self.banner.delegate = self.reporter;
    self.reporter.event = event;
    self.banner.frame = CGRectMake(0, 0, adSize.width, adSize.height);
    if ([BUAdSDKManager initializationState] == BUAdSDKInitializationStateReady) {
        [self.banner loadAdData];
    } else {
        [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.banner loadAdData];
                });
            }
        }];
    }
    return self.banner;
}
-(NSInteger)adapterEcpm{
    return 0;
}
@end
