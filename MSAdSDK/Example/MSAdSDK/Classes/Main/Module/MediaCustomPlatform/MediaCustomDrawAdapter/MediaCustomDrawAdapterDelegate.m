//
//  MediaCustomDrawAdapterDelegate.m
//  MSAdSDKDev
//
//  Created by leej on 2022/5/19.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MediaCustomDrawAdapterDelegate.h"

@implementation MediaCustomDrawAdapterDelegate

-(void)nativeExpressAdSuccessToLoad:(BUNativeExpressAdManager *)nativeExpressAdManager views:(NSArray<__kindof BUNativeExpressAdView *> *)views{
    if (views.count > 0) {
        if (self.successblock) {
            self.successblock(views.firstObject);
        }
        [self.event msCustomDrawAdLoadSuccess];
    }else{
        [self nativeExpressAdFailToLoad:nativeExpressAdManager error:nil];
    }
}
-(void)nativeExpressAdFailToLoad:(BUNativeExpressAdManager *)nativeExpressAdManager error:(NSError *)error{
    [self.event msCustomDrawAdLoadFailError:error];
}
-(void)nativeExpressAdViewWillPresentScreen:(BUNativeExpressAdView *)nativeExpressAdView{
    
}
-(void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView stateDidChanged:(BUPlayerPlayState)playerState{
    
}
-(void)nativeExpressAdViewRenderFail:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *)error{
    [self.event msCustomDrawAdVideoCacheFailedError:error];
}
-(void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterWords{
    
}
-(void)nativeExpressAdViewPlayerDidPlayFinish:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *)error{
    if (!error) {
        [self.event msCustomDrawAdVideoDidComplete];
    }else{
        [self.event msCustomDrawAdVideoPlayingFailedError:error];
    }
}
-(void)nativeExpressAdViewDidCloseOtherController:(BUNativeExpressAdView *)nativeExpressAdView interactionType:(BUInteractionType)interactionType{
    [self.event msCustomDrawAdVideoDetailClosed];
}
-(void)nativeExpressAdViewRenderSuccess:(BUNativeExpressAdView *)nativeExpressAdView{
    [self.event msCustomDrawAdVideoCacheSuccess];
}
-(void)nativeExpressAdViewDidRemoved:(BUNativeExpressAdView *)nativeExpressAdView{
    
}
-(void)nativeExpressAdViewWillShow:(BUNativeExpressAdView *)nativeExpressAdView{
    [self.event msCustomDrawAdVideoShowSuccess:nativeExpressAdView];
}
-(void)nativeExpressAdViewDidClick:(BUNativeExpressAdView *)nativeExpressAdView{
    [self.event msCustomDrawAdVideoDidClick:nativeExpressAdView];
}
@end
