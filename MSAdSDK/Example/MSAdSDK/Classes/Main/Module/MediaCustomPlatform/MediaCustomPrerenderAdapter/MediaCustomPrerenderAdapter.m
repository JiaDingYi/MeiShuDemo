//
//  MediaCustomPrerenderAdapter.m
//  MSAdSDKDev
//
//  Created by leej on 2022/5/20.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MediaCustomPrerenderAdapter.h"
#import "MediaSDKManager.h"
#import <BUAdSDK/BUAdSDK.h>
#import <MSAdSDK/MSCustomPrerenderEventProtocol.h>
#import "MediaCustomPrerenderAdapterDelegate.h"

@interface MediaCustomPrerenderAdapter ()
@property(nonatomic,strong)MSMediaInfoModel *model;
@property(nonatomic,strong)BUNativeExpressAdManager *manager;
@property(nonatomic,strong)MediaCustomPrerenderAdapterDelegate *reporter;
@end

@implementation MediaCustomPrerenderAdapter

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
    self.reporter = [[MediaCustomPrerenderAdapterDelegate alloc]init];
}
-(void)loadAdPid:(NSString *)pid
         adCount:(NSInteger)adCount
          adSize:(CGSize)adSize
       videoMute:(BOOL)mute
       presentVC:(UIViewController *)presentVC event:(id<MSCustomPrerenderEventProtocol>)event{
    self.reporter.event = event;
    self.reporter.presentVC = presentVC;
    BUAdSlot *slot = [[BUAdSlot alloc]init];
    BUSize *size = [BUSize sizeBy:BUProposalSize_Feed690_388];
    [slot setID:pid];
    [slot setAdType:BUAdSlotAdTypeFeed];
    [slot setImgSize:size];
    [slot setPosition:BUAdSlotPositionFeed];
    self.manager = [[BUNativeExpressAdManager alloc]initWithSlot:slot adSize:adSize];
    self.manager.delegate = self.reporter;
    if ([BUAdSDKManager initializationState] == BUAdSDKInitializationStateReady) {
        [self.manager loadAdDataWithCount:adCount];
    } else {
        [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.manager loadAdDataWithCount:adCount];
                });
            }
        }];
    }
}
-(NSInteger)adapterEcpm{
    return 0;
}
@end
