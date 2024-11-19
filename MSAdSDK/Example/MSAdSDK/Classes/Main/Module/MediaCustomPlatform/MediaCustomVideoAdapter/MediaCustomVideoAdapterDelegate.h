//
//  MediaCustomVideoAdapterDelegate.h
//  MSAdSDKDev
//
//  Created by leej on 2022/5/18.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GDTNativeExpressAd.h>
#import <MSAdSDK/MSCustomVideoEventProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface MediaCustomVideoAdapterDelegate : NSObject<GDTNativeExpressAdDelegete>
@property(nonatomic,weak)id<MSCustomVideoEventProtocol> event;
@property(nonatomic,copy)void(^successblock)(UIView *adView);
@end

NS_ASSUME_NONNULL_END
