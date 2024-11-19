//
//  MediaCustomRewardAdapter.m
//  MSAdSDKDev
//
//  Created by leej on 2022/5/17.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MediaCustomRewardAdapter.h"
#import "MediaCustomRewardAdapterDelegate.h"
#import "MediaSDKManager.h"
#import <BUAdSDK/BUAdSDK.h>

@interface MediaCustomRewardAdapter ()
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,strong)MSMediaInfoModel *model;
@property(nonatomic,strong)BUNativeExpressRewardedVideoAd *reward;
@property(nonatomic,strong)MediaCustomRewardAdapterDelegate *reporter;
@end

@implementation MediaCustomRewardAdapter

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
    self.reporter = [[MediaCustomRewardAdapterDelegate alloc]init];
}
-(void)loadAd:(NSString *)pid rewardEvent:(id<MSCustomRewardEventProtocol>)event{
    self.reporter.event = event;
    BURewardedVideoModel *model = [[BURewardedVideoModel alloc]init];
    model.userId = self.userId;//媒体需自行设置用户ID 此处传入的userid为demo演示使用
    self.reward = [[BUNativeExpressRewardedVideoAd alloc]initWithSlotID:pid rewardedVideoModel:model];
    self.reward.delegate = self.reporter;
    if ([BUAdSDKManager initializationState] == BUAdSDKInitializationStateReady) {
        [self.reward loadAdData];
    } else {
        [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.reward loadAdData];
                });
            }
        }];
    }
}
-(void)showAdFromVC:(UIViewController *)rootVC{
    [self.reward showAdFromRootViewController:rootVC];
}
-(NSInteger)adapterEcpm{
    return 0;
}
-(void)rewardUserId:(NSString *)userId{
    self.userId = userId;
}
-(BOOL)isAdValid{
    return YES;
}
@end
