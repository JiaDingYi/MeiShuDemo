//
//  MediaCustomSplashDelegate.m
//  MSAdSDKDev
//
//  Created by leej on 2022/4/26.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MediaCustomSplashDelegate.h"

@implementation MediaCustomSplashDelegate

/// This method is called when material load successful
- (void)splashAdLoadSuccess:(BUSplashAd *)splashAd{
    [self.reporter msCustomSplashEventSplashLoaded];
}

/// This method is called when material load failed
- (void)splashAdLoadFail:(BUSplashAd *)splashAd error:(BUAdError *_Nullable)error{
    [self.reporter msCustomSplashEventError:error];
}

/// This method is called when splash view render successful
- (void)splashAdRenderSuccess:(BUSplashAd *)splashAd{
    [self.reporter msCustomSplashEventRenderSuccess];
}

/// This method is called when splash view render failed
- (void)splashAdRenderFail:(BUSplashAd *)splashAd error:(BUAdError *_Nullable)error{
    [self.reporter msCustomSplashEventRenderFailedError:error];
}

/// This method is called when splash view will show
- (void)splashAdWillShow:(BUSplashAd *)splashAd{
    
}

/// This method is called when splash view did show
- (void)splashAdDidShow:(BUSplashAd *)splashAd{
    [self.reporter msCustomSplashEventSplashShow];
}

/// This method is called when splash view is clicked.
- (void)splashAdDidClick:(BUSplashAd *)splashAd{
    [self.reporter msCustomSplashEventSplashClicked];
}

/// This method is called when splash view is closed.
- (void)splashAdDidClose:(BUSplashAd *)splashAd closeType:(BUSplashAdCloseType)closeType{
    [self.reporter msCustomSplashEventSplashWillClosed];
    [self.reporter msCustomSplashEventSplashClosed];
}

/// This method is called when splash viewControllr is closed.
- (void)splashAdViewControllerDidClose:(BUSplashAd *)splashAd{
    
}

/**
 This method is called when another controller has been closed.
 @param interactionType : open appstore in app or open the webpage or view video ad details page.
 */
- (void)splashDidCloseOtherController:(BUSplashAd *)splashAd interactionType:(BUInteractionType)interactionType{
    [self.reporter msCustomSplashEventSplashDetailClosed];
}

/// This method is called when when video ad play completed or an error occurred.
- (void)splashVideoAdDidPlayFinish:(BUSplashAd *)splashAd didFailWithError:(NSError *)error{
    if (error) {
        [self.reporter msCustomSplashEventSplashAdShowFail:error];
        [splashAd removeSplashView];
    }
}
#pragma mark
/// This method is called when splash zoomout is ready to show.
- (void)splashZoomOutReadyToShow:(BUSplashAd *)splashAd{
    
}

/// This method is called when splash zoomout is clicked.
- (void)splashZoomOutViewDidClick:(BUSplashAd *)splashAd{
    
}

/// This method is called when splash zoomout is closed.
- (void)splashZoomOutViewDidClose:(BUSplashAd *)splashAd{
    
}
@end
