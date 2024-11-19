//
//  MediaCustomInterstitialDelegate.h
//  MSAdSDKDev
//
//  Created by leej on 2022/5/17.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUAdSDK.h>
#import <MSAdSDK/MSCustomInterstitialEventProtocol.h>

NS_ASSUME_NONNULL_BEGIN
@interface MediaCustomInterstitialDelegate : NSObject<BUNativeExpressFullscreenVideoAdDelegate>
@property(nonatomic,weak)id<MSCustomInterstitialEventProtocol>event;
@end

NS_ASSUME_NONNULL_END
