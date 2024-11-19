//
//  MediaCustomSplashDelegate.h
//  MSAdSDKDev
//
//  Created by leej on 2022/4/26.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUAdSDK.h>
#import <MSAdSDK/MSCustomSplashEventProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface MediaCustomSplashDelegate : NSObject<BUSplashAdDelegate,BUSplashZoomOutDelegate>
@property(nonatomic,weak)id<MSCustomSplashEventProtocol>reporter;
@end

NS_ASSUME_NONNULL_END
