//
//  MediaCustomVideoAdapterDelegate.m
//  MSAdSDKDev
//
//  Created by leej on 2022/5/18.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MediaCustomVideoAdapterDelegate.h"
#import <GDTNativeExpressAdView.h>

@interface MediaCustomVideoAdapterDelegate ()

@end

@implementation MediaCustomVideoAdapterDelegate

-(void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView{
    [self.event msCustomVideoClose:(UIView *)nativeExpressAdView];
}
-(void)nativeExpressAdViewClicked:(GDTNativeExpressAdView *)nativeExpressAdView{
    [self.event msCustomVideoClick:(UIView *)nativeExpressAdView];
}
-(void)nativeExpressAdViewExposure:(GDTNativeExpressAdView *)nativeExpressAdView{
    [self.event msCustomVideoShow:(UIView *)nativeExpressAdView];
}
-(void)nativeExpressAdViewRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView{
    [self.event msCustomVideoError:[NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:nil]];
}
-(void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView{
    CGRect baseFrame = nativeExpressAdView.superview.frame;
    nativeExpressAdView.superview.frame = CGRectMake(baseFrame.origin.x, baseFrame.origin.y, nativeExpressAdView.frame.size.width, nativeExpressAdView.frame.size.height);
    [self.event msCustomVideoResize:(UIView *)nativeExpressAdView adSize:nativeExpressAdView.frame.size];
}
-(void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error{
    [self.event msCustomVideoError:error];
}
-(void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views{
    if (views.count > 0) {
        if (self.successblock) {
            self.successblock((UIView *)views.firstObject);
        }
        [self.event msCustomVideoLoad];
    }else{
        [self nativeExpressAdFailToLoad:nativeExpressAd error:nil];
    }
}
-(void)nativeExpressAdView:(GDTNativeExpressAdView *)nativeExpressAdView playerStatusChanged:(GDTMediaPlayerStatus)status{
    if (status == GDTMediaPlayerStatusError) {
        [self.event msCustomVideoPlayingError:nativeExpressAdView error:[NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:nil]];
    }else if (status == GDTMediaPlayerStatusStoped){
        [self.event msCustomVideoCompletion:nativeExpressAdView];
    }
}
@end
