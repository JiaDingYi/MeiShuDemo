//
//  MediaCustomVideoAdapter.m
//  MSAdSDKDev
//
//  Created by leej on 2022/5/18.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MediaCustomVideoAdapter.h"
#import "MediaSDKManager.h"
#import <GDTNativeExpressAd.h>
#import <GDTNativeExpressAdView.h>
#import <GDTSDKConfig.h>
#import <MSAdSDK/MSCustomVideoEventProtocol.h>
#import "MediaCustomVideoAdapterDelegate.h"

@interface MediaCustomVideoAdapter ()
@property(nonatomic,strong)UIView *baseView;
@property(nonatomic,strong)GDTNativeExpressAdView *gdtView;
@property(nonatomic,strong)GDTNativeExpressAd *manager;
@property(nonatomic,strong)MSMediaInfoModel *model;
@property(nonatomic,strong)MediaCustomVideoAdapterDelegate *reporter;
@end

@implementation MediaCustomVideoAdapter

-(void)registSdkWithInfo:(NSDictionary *)info{
    self.model = [[MSMediaInfoModel alloc]initWithDict:info];
    if (![[MediaSDKManager shareSdkManager] registThirdSdkAppid:self.model.appid]) {
        [GDTSDKConfig registerAppId:self.model.appid];
    }
    self.reporter = [[MediaCustomVideoAdapterDelegate alloc]init];
}
-(UIView *)loadAndShow:(NSString *)pid
             presentVC:(UIViewController *)presentVC
                adSize:(CGSize)adSize
            videoEvent:(id<MSCustomVideoEventProtocol>)event{
    self.reporter.event = event;
    self.baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, adSize.width, adSize.height)];
    self.manager = [[GDTNativeExpressAd alloc]initWithPlacementId:pid adSize:adSize];
    self.manager.delegate = self.reporter;
    [self.manager loadAd:1];
    __weak typeof(self)weakSelf = self;
    __weak UIViewController *weakVC = presentVC;
    self.reporter.successblock = ^(UIView * _Nonnull adView) {
        [weakSelf.baseView addSubview:adView];
        weakSelf.gdtView = (GDTNativeExpressAdView *)adView;
        [weakSelf.gdtView render];
        weakSelf.gdtView.controller = weakVC;
    };
    return self.baseView;
}
-(void)playVideo{
    
}
-(void)pauseVideo{
    
}
-(void)muteVideo:(BOOL)mute{
    self.manager.videoMuted = mute;
}
-(void)reSize:(CGRect)frame{
    
}
-(NSTimeInterval)currentPlayTime{
    CGFloat time = [self.gdtView videoPlayTime];
    if (time > 0) {
        time = time/1000;
    }
    return (NSTimeInterval)time;
}
-(NSTimeInterval)totalVideoTime{
    CGFloat time = [self.gdtView videoDuration];
    if (time > 0) {
        time = time/1000;
    }
    return (NSTimeInterval)time;
}
-(NSInteger)adapterEcpm{
    return [self.gdtView eCPM];
}
-(void)updatePlatformAdPresentVc:(UIViewController *)presentVC{
    self.gdtView.controller = presentVC;
}
-(BOOL)isAdValid{
    return [self.gdtView isAdValid];
}
@end
