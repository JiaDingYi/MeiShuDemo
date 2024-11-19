//
//  MSAppDelegate.m
//  MSAdSDK
//
//  Created by Liumao on 08/10/2020.
//  Copyright (c) 2020 Liumao. All rights reserved.
//

#import "MSAppDelegate.h"
#import "HomeViewController.h"
#import "MSDemoSplashViewController.h"
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <CoreLocation/CoreLocation.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface MSAppDelegate ()<MSDemoSplashDelegate,CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *locationManager;
@end

@implementation MSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setUpSDK];
    [self setUpMainVc];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    return YES;
}
- (void)setUpSDK{
    NSString *appid = @"101647";
    [MSAdSDK startSDKWithAppid:appid configBlock:^{
        [MSAdSDK setLogLevel:MSLogNone];
        [MSConfig setYob:@"2000"];
        [MSConfig setGender:MSGenderFemale];
        //新版初始化微信小程序接口已迁移至平台广告位上，具体配置方法请参考接入文档
        //[MSConfig setWXAppId:@"your WXAppId" universalLink:@"your universalLink"];
    }];
    [self setUpIDFA];
    [self openGPS];
}
-(void)setUpMainVc{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    //    [self startWithSplashAd];
    [self startWithoutSplashAd];
}
- (void)openGPS{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
        //此处仅调试测试使用
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if ([CLLocationManager locationServicesEnabled]) {
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager startUpdatingLocation];
        }
    });
}
- (void)setUpIDFA{
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            if (status == ATTrackingManagerAuthorizationStatusAuthorized)
                {
                 NSString *idfaString = [[[ASIdentifierManager
                 sharedManager] advertisingIdentifier] UUIDString];
                [MSLogger logTestInfo:idfaString];
                 }
             }];
     } else {
        //使用原方式访问 IDFA
         if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
         NSString *idfaString = [[ASIdentifierManager sharedManager]
         advertisingIdentifier].UUIDString;
         [MSLogger logTestInfo:idfaString];
        }
    };
}
-(void)startWithSplashAd{
    MSDemoSplashViewController *splashvc = [[MSDemoSplashViewController alloc]initWithNibName:nil bundle:nil];
    splashvc.delegate = self;
    self.window.rootViewController = splashvc;
}
-(void)startWithoutSplashAd{
    UIViewController *vc = [[HomeViewController alloc]initWithNibName:nil bundle:nil];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = navi;
}
#pragma mark-
-(void)splashAdDidFinished{
    [self startWithoutSplashAd];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [self.locationManager stopUpdatingLocation];
    NSLog(@"当前位置%@",locations.lastObject);
}
@end
