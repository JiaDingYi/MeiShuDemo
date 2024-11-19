//
//  MSDefaultSet.m
//  MSAdSDKDev
//
//  Created by Liumaos on 2020/7/17.
//  Copyright © 2020 XiXiHaha. All rights reserved.
//

#import "MSDefaultSet.h"

@implementation MSDefaultSet

+(NSDictionary *)defaultIdPriders{
    return @{
        MSPlatformNameMS :@"MSIdProvider",
        MSPlatformNameBU :@"BUIdProvider",
        MSPlatformNameGDT:@"GDTIdProvider",
        MSPlatformNameBD :@"BDIdProvider",
        MSPlatformNameJD :@"JDIdProvider",
        MSPlatformNameKS :@"KSIdProvider",
        MSPlatformNameADMOB :@"AdmobIdProvider",
        MSPlatformNameCP : @"MSCustomAdapterIdProvider"
    };
}
+ (NSDictionary *)defaultAdVcs{
    return @{
        @(MSAdTypeSplash) :@"MSSplashViewController",
        @(MSAdTypeReward) :@"MSRewardVideoViewController",
        @(MSAdTypeBanner) :@"MSBannerViewController",
        @(MSAdTypeInterstitial):@"MSInterstitialViewController",
        @(MSAdTypePaster):@"MSVideoAdViewController",
        @(MSAdTypeFeed)   :@"MSFeedViewController",
        @(MSAdTypeFeedPreRender)   :@"MSPreRenderViewController",
        @(MSAdTypeNativeExpressAd) :@"MSNativeFeedAdSimpleViewController",
        @(MSAdTypeFullScreenVideo) :@"MSFullScreenVideoViewController",
        @(MSAdTypeDraw):@"MSDrawAdViewController"
    };
}

@end
