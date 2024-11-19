//
//  MediaCustomBannerAdapterDelegate.h
//  MSAdSDKDev
//
//  Created by leej on 2022/5/17.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUAdSDK.h>
#import <MSAdSDK/MSCustomBannerEventProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface MediaCustomBannerAdapterDelegate : NSObject<BUNativeExpressBannerViewDelegate>
@property(nonatomic,weak)id<MSCustomBannerEventProtocol> event;
@end

NS_ASSUME_NONNULL_END
