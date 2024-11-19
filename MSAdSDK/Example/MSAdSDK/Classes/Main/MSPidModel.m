//
//  MSPidModel.m
//  MSAdSDKDev
//
//  Created by Liumaos on 2020/7/17.
//  Copyright © 2020 XiXiHaha. All rights reserved.
//

#import "MSPidModel.h"
#import "MSDefaultSet.h"


@implementation MSPidModel

+(instancetype)modelIn:(MSPlatformName)platform adtype:(MSAdType)adtype{
    MSPidModel *model = [[MSPidModel alloc]init];
    model.platform    = platform;
    model.adType      = adtype;
    return model;
}
-(NSString *)vc{
    return [[MSDefaultSet defaultAdVcs]objectForKey:@(self.adType)];
}
-(NSString *)pid{
    return [IdProviderFactory getPidFor:self.platform adType:self.adType];
}
-(NSString *)moduleName{
    switch (self.adType) {
        case MSAdTypeSplash:
            return @"开屏";
        case MSAdTypeReward:
            return @"激励视频";
        case  MSAdTypeBanner:
            return @"Banner";
        case MSAdTypeInterstitial:
            return @"插页";
        case MSAdTypePaster:
            return @"贴片广告";
        case MSAdTypeFeed:
            return @"自渲染信息流";
        case MSAdTypeFeedPreRender:
            return @"模板信息流";
        case MSAdTypeNativeExpressAd:
            return @"新版信息流";
        case MSAdTypeFullScreenVideo:
            return @"全屏视频";
        case MSAdTypeDraw:
            return @"Draw广告";
        default:
            break;
    }
    return nil;
}
@end
