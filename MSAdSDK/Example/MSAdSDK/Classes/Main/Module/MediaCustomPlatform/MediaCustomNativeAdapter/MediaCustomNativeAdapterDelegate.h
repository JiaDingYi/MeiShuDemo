//
//  MediaCustomNativeAdapterDelegate.h
//  MSAdSDKDev
//
//  Created by leej on 2022/5/23.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KSAdSDK/KSAdSDK.h>
#import <MSAdSDK/MSCustomNativeEventProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface MediaCustomNativeAdapterDelegate : NSObject<KSNativeAdsManagerDelegate,KSNativeAdDelegate>
@property(nonatomic,weak)id<MSCustomNativeEventProtocol> event;
@property(nonatomic,weak)UIViewController *presentVC;
@property(nonatomic,assign)NSInteger ecpm;
@end

NS_ASSUME_NONNULL_END
