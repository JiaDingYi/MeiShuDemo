//
//  MediaCustomNativeAdapterDelegate.m
//  MSAdSDKDev
//
//  Created by leej on 2022/5/23.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MediaCustomNativeAdapterDelegate.h"
#import "MediaCustomFeedAdMeta.h"
#import <UIImageView+WebCache.h>

@interface MediaCustomNativeAdapterDelegate ()
@property(nonatomic,strong)NSMutableArray *datas;
@end

@implementation MediaCustomNativeAdapterDelegate
/**
 广告加载成功
 在此回调中填充广告物料
 */
- (void)nativeAdsManagerSuccessToLoad:(KSNativeAdsManager *)adsManager nativeAds:(NSArray<KSNativeAd *> *_Nullable)nativeAdDataArray{
    if (nativeAdDataArray.count > 0) {
        BOOL isEcpm = NO;
        self.datas = [[NSMutableArray alloc]initWithCapacity:nativeAdDataArray.count];
        for (KSNativeAd *native in nativeAdDataArray) {
            KSMaterialMeta *data = native.data;
            if (!isEcpm) {
                self.ecpm = native.ecpm;
                isEcpm = YES;
            }
            MediaCustomFeedAdMeta *meta = [[MediaCustomFeedAdMeta alloc]init];
            meta.loadSuccessTime = [[NSDate date]timeIntervalSince1970];
            meta.content = data.adDescription;
            if (data) {
                if (data.materialType == KSAdMaterialTypeUnkown) {
                    meta.creativeType = MSCreativeTypeSmallImage;
                } else if (data.materialType == KSAdMaterialTypeSingle) {
                    meta.creativeType = MSCreativeTypeLargeImage;
                } else if (data.materialType == KSAdMaterialTypeAtlas) {
                    meta.creativeType = MSCreativeTypeThreeImage;
                } else if (data.materialType == KSAdMaterialTypeVideo){
                    meta.creativeType = MSCreativeTypeVideo;
                }
            }
            if (data.imageArray.count>0) {
                NSMutableArray *imgs = [[NSMutableArray alloc]initWithCapacity:data.imageArray.count];
                for (KSAdImage *image in data.imageArray) {
                    meta.mainImageSize = CGSizeMake(image.width, image.height);
                    [imgs addObject:image.imageURL];
                }
                if (meta.creativeType == MSCreativeTypeThreeImage) {
                    meta.imageUrls = imgs;
                }else{
                    meta.imageUrls = [NSArray arrayWithObjects:imgs.firstObject, nil];
                }
            }
            meta.icon = data.appIconImage.imageURL;
            NSString *logoUrl = [data adSourceLogoURL:KSAdSourceLogoTypeGray];
            if (!logoUrl) {
                logoUrl = [data adSourceLogoURL:KSAdSourceLogoTypeWhite];
            }
            meta.logo = [[UIImageView alloc]init];
            if (logoUrl) {
                [meta.logo sd_setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil];
            }
            meta.videoDuration = data.videoDuration;
            meta.source = data.adSource;
            if (data.appDownloadCountDesc.length > 0) {
                meta.appDownloadCountDesc = data.appDownloadCountDesc;
            }
            if (data.appScore > 0) {
                meta.appScore = [NSString stringWithFormat:@"%lf",data.appScore];
            }
            meta.actionTitle = data.actionDescription;
            native.delegate = self;
            native.rootViewController = self.presentVC;
            meta.thirdPlatformNativeData = native;
            [self.datas addObject:meta];
        }
        [self.event msCustomNativeLoaded:self.datas];
    }else{
        [self nativeAdsManager:adsManager didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:204 userInfo:@{}]];
    }
}
- (void)nativeAdsManager:(KSNativeAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error{
    [self.event msCustomNativeError:error];
}
/**
 This method is called when native ad show everytime. Please don‘t use for exposure count. Please use 'nativeAdDidShow' for exposure count.
 */
- (void)nativeAdDidBecomeVisible:(KSNativeAd *)nativeAd{
    
}
/**
 This method is called when native ad show. Each ad is called back only once
 */
- (void)nativeAdDidShow:(KSNativeAd *)nativeAd{
    id<MSFeedAdMeta> meta = nil;
    for (MediaCustomFeedAdMeta *ad in self.datas) {
        if (ad.thirdPlatformNativeData == nativeAd) {
            meta = ad;
            break;
        }
    }
    MediaCustomFeedAdMeta *cMeta = (MediaCustomFeedAdMeta *)meta;
    [self.event msCustomNativeShow:meta adContainerView:cMeta.adSuperView];
}
/**
 This method is called when native ad is clicked.
 */
- (void)nativeAdDidClick:(KSNativeAd *)nativeAd withView:(UIView *_Nullable)view{
    id<MSFeedAdMeta> meta = nil;
    for (MediaCustomFeedAdMeta *ad in self.datas) {
        if (ad.thirdPlatformNativeData == nativeAd) {
            meta = ad;
            break;
        }
    }
    [self.event msCustomNativeClick:meta];
}
/**
This method is called when another controller has been showed.
@param interactionType : open appstore in app or open the webpage or view video ad details page.
*/
- (void)nativeAdDidShowOtherController:(KSNativeAd *)nativeAd interactionType:(KSAdInteractionType)interactionType{
    [self.event msCustomNativeDetailShow];
}
/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)nativeAdDidCloseOtherController:(KSNativeAd *)nativeAd interactionType:(KSAdInteractionType)interactionType{
    [self.event msCustomNativeDetailClosed];
}
@end
