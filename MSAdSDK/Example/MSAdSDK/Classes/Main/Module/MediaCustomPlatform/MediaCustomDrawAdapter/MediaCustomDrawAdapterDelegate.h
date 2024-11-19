//
//  MediaCustomDrawAdapterDelegate.h
//  MSAdSDKDev
//
//  Created by leej on 2022/5/19.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUAdSDK.h>
#import <MSAdSDK/MSCustomDrawEventProtocol.h>
NS_ASSUME_NONNULL_BEGIN

@interface MediaCustomDrawAdapterDelegate : NSObject<BUNativeExpressAdViewDelegate>
@property(nonatomic,weak)id<MSCustomDrawEventProtocol> event;
@property(nonatomic,copy)void(^successblock)(UIView *adView);
@end

NS_ASSUME_NONNULL_END
