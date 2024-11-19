//
//  MediaCustomBannerAdapterDelegate.m
//  MSAdSDKDev
//
//  Created by leej on 2022/5/17.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MediaCustomBannerAdapterDelegate.h"

@implementation MediaCustomBannerAdapterDelegate
/**
 This method is called when bannerAdView ad slot loaded successfully.
 @param bannerAdView : view for bannerAdView
 */
- (void)nativeExpressBannerAdViewDidLoad:(BUNativeExpressBannerView *)bannerAdView{
    [self.event msCustomBannerLoaded:bannerAdView];
}
/**
 This method is called when bannerAdView ad slot failed to load.
 @param error : the reason of error
 */
- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView didLoadFailWithError:(NSError *_Nullable)error{
    [self.event msCustomBannerError:error];
}
/**
 This method is called when rendering a nativeExpressAdView successed.
 */
- (void)nativeExpressBannerAdViewRenderSuccess:(BUNativeExpressBannerView *)bannerAdView{
    [self.event msCustomBannerAdRenderSuccess:bannerAdView];
}
/**
 This method is called when a nativeExpressAdView failed to render.
 @param error : the reason of error
 */
- (void)nativeExpressBannerAdViewRenderFail:(BUNativeExpressBannerView *)bannerAdView error:(NSError * __nullable)error{
    [self.event msCustomBannerAdRenderFail:bannerAdView error:error];
}
/**
 This method is called when bannerAdView ad slot showed new ad.
 */
- (void)nativeExpressBannerAdViewWillBecomVisible:(BUNativeExpressBannerView *)bannerAdView{
    [self.event msCustomBannerShow:bannerAdView];
}
/**
 This method is called when bannerAdView is clicked.
 */
- (void)nativeExpressBannerAdViewDidClick:(BUNativeExpressBannerView *)bannerAdView{
    [self.event msCustomBannerClicked:bannerAdView];
}
/**
 This method is called when the user clicked dislike button and chose dislike reasons.
 @param filterwords : the array of reasons for dislike.
 */
- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView dislikeWithReason:(NSArray<BUDislikeWords *> *_Nullable)filterwords{
    [self.event msCustomBannerClosed:bannerAdView];
}
/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
-(void)nativeExpressBannerAdViewDidCloseOtherController:(BUNativeExpressBannerView *)bannerAdView interactionType:(BUInteractionType)interactionType{
    [self.event msCustomBannerDetailClosed:bannerAdView];
}
/**
 This method is called when the Ad view container is forced to be removed.
 @param bannerAdView : Express Banner Ad view container
 */
- (void)nativeExpressBannerAdViewDidRemoved:(BUNativeExpressBannerView *)bannerAdView{
    
}
@end
