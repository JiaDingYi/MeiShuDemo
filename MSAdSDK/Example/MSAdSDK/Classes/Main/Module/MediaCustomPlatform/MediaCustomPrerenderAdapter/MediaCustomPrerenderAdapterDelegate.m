//
//  MediaCustomPrerenderAdapterDelegate.m
//  MSAdSDKDev
//
//  Created by leej on 2022/5/20.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MediaCustomPrerenderAdapterDelegate.h"

@interface MediaCustomPrerenderAdapterDelegate ()
@property(nonatomic,assign)BOOL isSend;
@end

@implementation MediaCustomPrerenderAdapterDelegate

-(void)nativeExpressAdSuccessToLoad:(BUNativeExpressAdManager *)nativeExpressAdManager views:(NSArray<__kindof BUNativeExpressAdView *> *)views{
    if (views.count > 0) {
        for (BUNativeExpressAdView *view in views) {
            [view setRootViewController:self.presentVC];
            [view render];
        }
        [self.event msCustomPrerenderLoaded:views];
    }else{
        [self nativeExpressAdFailToLoad:nativeExpressAdManager error:nil];
    }
}
-(void)nativeExpressAdFailToLoad:(BUNativeExpressAdManager *)nativeExpressAdManager error:(NSError *)error{
    [self.event msCustomPrerenderError:error];
}
-(void)nativeExpressAdViewWillPresentScreen:(BUNativeExpressAdView *)nativeExpressAdView{
    
}
-(void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView stateDidChanged:(BUPlayerPlayState)playerState{
    MSPlayerPlayState msStatus = 0;
    if (playerState == 0) {
        msStatus = MSPlayerStateFailed;
    }else if (playerState == 2){
        if (!self.isSend) {
            self.isSend = YES;
            [self.event msCustomPrerenderPlayerStatus:MSPlayerStateStarted adView:nativeExpressAdView];
        }
        msStatus = MSPlayerStatePlaying;
    }else if (playerState == 3){
        msStatus = MSPlayerStateStopped;
    }else if (playerState == 4){
        msStatus = MSPlayerStatePause;
    }
    [self.event msCustomPrerenderPlayerStatus:msStatus adView:nativeExpressAdView];
}
-(void)nativeExpressAdViewRenderFail:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *)error{
    [self.event msCustomPrerenderRenderError:nativeExpressAdView error:error];
}
-(void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterWords{
    [self.event msCustomPrerenderClosed:nativeExpressAdView];
}
-(void)nativeExpressAdViewPlayerDidPlayFinish:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *)error{
    
}
-(void)nativeExpressAdViewDidCloseOtherController:(BUNativeExpressAdView *)nativeExpressAdView interactionType:(BUInteractionType)interactionType{
    
}
-(void)nativeExpressAdViewRenderSuccess:(BUNativeExpressAdView *)nativeExpressAdView{
    [self.event msCustomPrerenderRenderSuccess:nativeExpressAdView adInfo:@{}];
}
-(void)nativeExpressAdViewDidRemoved:(BUNativeExpressAdView *)nativeExpressAdView{
    
}
-(void)nativeExpressAdViewWillShow:(BUNativeExpressAdView *)nativeExpressAdView{
    [self.event msCustomPrerenderShow:nativeExpressAdView];
}
-(void)nativeExpressAdViewDidClick:(BUNativeExpressAdView *)nativeExpressAdView{
    [self.event msCustomPrerenderClicked:nativeExpressAdView];
}
@end
