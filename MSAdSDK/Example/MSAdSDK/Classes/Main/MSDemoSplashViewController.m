//
//  MSDemoSplashViewController.m
//  MSAdSDKDev
//
//  Created by Liumaos on 2020/8/5.
//  Copyright © 2020 Adxdata. All rights reserved.
//

#import "MSDemoSplashViewController.h"
#import "IdProviderFactory.h"

@interface MSDemoSplashViewController ()<MSSplashAdDelegate>
@property(nonatomic,strong) MSSplashAd *splash;
@end

@implementation MSDemoSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blueColor;
    [self loadAd];
}
-(void)loadAd{
    MSSplashAd *splash = [[MSSplashAd alloc]init];
    self.splash = splash;
    splash.delegate = self;
    NSString *pid = [IdProviderFactory getPidFor:MSPlatformNameMS adType:MSAdTypeSplash];
    MSSplashAdConfigParams *adParam = [[MSSplashAdConfigParams alloc]init];
    adParam.adSize = self.view.bounds.size;
    adParam.hideSplashStatusBar = YES;
    [self.splash loadAndShowSplashAdWithPid:pid adParam:adParam inWindow:[UIApplication sharedApplication].keyWindow];
}
-(void)splashAdDidFinished{
    if ([self.delegate respondsToSelector:@selector(splashAdDidFinished)]) {
        [self.delegate splashAdDidFinished];
    }
}
#pragma mark- <MSSplashAdDelegate>
- (void)msSplashClicked:(MSSplashAd *)splashAd {
    NSLog(@"msSplashClicked");
}
- (void)msSplashClosed:(MSSplashAd *)splashAd {
    [self splashAdDidFinished];
    NSLog(@"msSplashClosed");
}
- (void)msSplashDetailClosed:(MSSplashAd *)splashAd {
    NSLog(@"msSplashDetailClosed");
}
- (void)msSplashError:(MSSplashAd *)splashAd
            withError:(NSError *)error {
    [self splashAdDidFinished];
}
- (void)msSplashLoaded:(MSSplashAd *)splashAd {
    
}
-(void)msSplashPresent:(MSSplashAd *)splashAd{
    
}
- (void)msSplashShow:(MSSplashAd *)splashAd {
    
}
- (void)msSplashSkip:(MSSplashAd *)splashAd {
    [self splashAdDidFinished];
}
- (void)msSplashWillClosed:(MSSplashAd *)splashAd {
    NSLog(@"msSplashWillClosed");
}
- (void)msSplashStartLoaded:(MSSplashAd *)splashAd {
    
}
- (void)msSplashPlatformError:(MSPlatform)platform
                     splashAd:(MSSplashAd *)splashAd
                        error:(NSError *)error {
}

@end
