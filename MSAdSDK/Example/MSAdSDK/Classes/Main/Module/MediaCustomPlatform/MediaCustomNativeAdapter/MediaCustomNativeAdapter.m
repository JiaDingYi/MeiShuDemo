//
//  MediaCustomNativeAdapter.m
//  MSAdSDKDev
//
//  Created by leej on 2022/5/23.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MediaCustomNativeAdapter.h"
#import "MediaSDKManager.h"
#import <KSAdSDK/KSAdSDK.h>
#import <MSAdSDK/MSCustomNativeAdapterProtocol.h>
#import <MSAdSDK/MSCustomNativeEventProtocol.h>
#import "MediaCustomNativeAdapterDelegate.h"

@interface MediaCustomNativeAdapter ()<MSCustomNativeAdapterProtocol>
@property(nonatomic,strong)KSNativeAdsManager *manager;
@property(nonatomic,strong)MSMediaInfoModel *model;
@property(nonatomic,strong)MediaCustomNativeAdapterDelegate *reporter;
@end

@implementation MediaCustomNativeAdapter

-(void)registSdkWithInfo:(NSDictionary *)info{
    self.model = [[MSMediaInfoModel alloc]initWithDict:info];
    if (![[MediaSDKManager shareSdkManager] registThirdSdkAppid:self.model.appid]) {
        [[KSAdSDKConfiguration configuration]setAppId:self.model.appid];
    }
    self.reporter = [[MediaCustomNativeAdapterDelegate alloc]init];
}
-(void)loadAdPid:(NSString *)pid
         adCount:(NSInteger)adCount
       presentVC:(UIViewController *)presentVC event:(id<MSCustomNativeEventProtocol>)event{
    self.reporter.event = event;
    self.reporter.presentVC = presentVC;
    self.manager = [[KSNativeAdsManager alloc]initWithPosId:pid];
    self.manager.delegate = self.reporter;
    [self.manager loadAdDataWithCount:adCount];
}
-(NSInteger)adapterEcpm{
    return self.reporter.ecpm;
}
-(void)configMediaParamsOnPlatform:(NSDictionary *)mediaParams{
    
}
@end
