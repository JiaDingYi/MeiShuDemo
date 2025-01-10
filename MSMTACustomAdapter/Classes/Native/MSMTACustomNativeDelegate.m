//
//  MSMTACustomNativeDelegate.m
//  MSMTACustomAdapter
//
//  Created by jdy on 2025/1/9.
//

#import "MSMTACustomNativeDelegate.h"
#import "MSMTACustomFeedAdMeta.h"
#import <MentaVlionBaseSDK/MentaVlionBaseSDK-umbrella.h>

@interface MSMTACustomNativeDelegate ()
@property(nonatomic,strong)NSMutableArray *datas;

@end

@implementation MSMTACustomNativeDelegate

/// 广告策略服务加载成功
- (void)menta_didFinishLoadingADPolicy:(MentaUnifiedNativeAd *_Nonnull)nativeAd {
    
}

/**
 广告数据回调
 */
- (void)menta_nativeAdLoaded:(NSArray<MentaNativeObject *> * _Nullable)unifiedNativeAdDataObjects nativeAd:(MentaUnifiedNativeAd *_Nullable)nativeAd {
    if (unifiedNativeAdDataObjects.count > 0) {
        BOOL isEcpm = NO;
        self.datas = [[NSMutableArray alloc]initWithCapacity:unifiedNativeAdDataObjects.count];
        for (MentaNativeObject *native in unifiedNativeAdDataObjects) {
            MentaNativeAdDataObject *data = native.dataObject;
            if (!isEcpm) {
                self.ecpm = data.price.doubleValue;
                isEcpm = YES;
            }
            MSMTACustomFeedAdMeta *meta = [[MSMTACustomFeedAdMeta alloc]init];
            meta.loadSuccessTime = [[NSDate date]timeIntervalSince1970];
            meta.content = data.desc;
            if (data) {
                if (data.isVideo) {
                    meta.creativeType = MSCreativeTypeVideo;
                } else {
                    meta.creativeType = MSCreativeTypeImage;
                }
            }
            if (data.materialList.count>0) {
                NSMutableArray *imgs = [[NSMutableArray alloc]initWithCapacity:data.materialList.count];
                for (MentaNativeAdMaterialObject *image in data.materialList) {
                    meta.mainImageSize = CGSizeMake(image.materialWidth, image.materialHeight);
                    [imgs addObject:image.materialUrl];
                }
                meta.imageUrls = imgs;
            }
            
            meta.icon = data.iconUrl;
            NSString *logoUrl = @"https://bj-menta-sdk.oss-cn-beijing.aliyuncs.com/menta_logo/menta%E8%A7%92%E6%A0%87%403x.png";
            meta.logo = [[UIImageView alloc]init];
            if (logoUrl) {
                [meta.logo mvyy_setImageWithURL:[NSURL URLWithString:logoUrl] placeholder:nil];
            }
            meta.videoDuration = data.videoDuration;
            meta.source = @"MTA";
            meta.thirdPlatformNativeData = native;
            [self.datas addObject:meta];
        }
        [self.event msCustomNativeLoaded:self.datas];
    }else{
        [self.event msCustomNativeError:[NSError errorWithDomain:@"" code:101 userInfo:@{}]];
    }
}

/// 信息流自渲染加载失败
- (void)menta_nativeAd:(MentaUnifiedNativeAd *_Nonnull)nativeAd didFailWithError:(NSError * _Nullable)error description:(NSDictionary *_Nonnull)description {
    [self.event msCustomNativeError:error];
}

/**
 广告曝光回调,
 */
- (void)menta_nativeAdViewWillExpose:(MentaUnifiedNativeAd *_Nullable)nativeAd adView:(UIView<MentaNativeAdViewProtocol> *_Nonnull)adView {
    id<MSFeedAdMeta> meta = nil;
    MSMTACustomFeedAdMeta *cMeta = (MSMTACustomFeedAdMeta *)meta;
    [self.event msCustomNativeShow:cMeta adContainerView:cMeta.adSuperView];
}


/**
 广告点击回调,

 @param nativeAd MentaUnifiedNativeAd 实例,
 */
- (void)menta_nativeAdViewDidClick:(MentaUnifiedNativeAd *_Nullable)nativeAd adView:(UIView<MentaNativeAdViewProtocol> *_Nullable)adView {
    id<MSFeedAdMeta> meta = nil;
    MSMTACustomFeedAdMeta *cMeta = (MSMTACustomFeedAdMeta *)meta;
    [self.event msCustomNativeClick:cMeta];
}

/**
 广告点击关闭回调 UI的移除和数据的解绑 需要在该回调中进行
 */
- (void)menta_nativeAdDidClose:(MentaUnifiedNativeAd *_Nonnull)nativeAd adView:(UIView<MentaNativeAdViewProtocol> *_Nullable)adView {
    
}


/**
 广告详情页面即将展示回调, 当广告位落地页广告时会触发

 @param nativeAd MentaUnifiedNativeAd 实例,
 */
- (void)menta_nativeAdDetailViewWillPresentScreen:(MentaUnifiedNativeAd *_Nullable)nativeAd adView:(UIView<MentaNativeAdViewProtocol> *_Nonnull)adView {
    
}


/**
 广告详情页关闭回调,即落地页关闭回调, 当关闭弹出的落地页时 触发
 */
- (void)menta_nativeAdDetailViewClosed:(MentaUnifiedNativeAd *_Nullable)nativeAd adView:(UIView<MentaNativeAdViewProtocol> *_Nonnull)adView {
    
}


/**
 信息流自渲染视频播放结束

 @param nativeAd MentaUnifiedNativeAd 实例,
 */
- (void)menta_nativeAdDidPlayFinished:(MentaUnifiedNativeAd *_Nullable)nativeAd adView:(UIView<MentaNativeAdViewProtocol> *_Nonnull)adView {
    
}

/**
 信息流自渲染视频播放失败

 @param nativeAd MentaUnifiedNativeAd 实例,
 */
- (void)menta_nativeAdDidPlayFailed:(MentaUnifiedNativeAd *_Nullable)nativeAd adView:(UIView<MentaNativeAdViewProtocol> *_Nonnull)adView error:(NSError *_Nullable)error {
    
}

@end
