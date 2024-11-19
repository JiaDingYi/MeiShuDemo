//
//  MediaCustomFullScreenVideoAdapterDelegate.h
//  MSAdSDKDev
//
//  Created by leej on 2022/5/19.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUAdSDK.h>
#import <MSAdSDK/MSCustomFullScreenVideoEventProtocol.h>
NS_ASSUME_NONNULL_BEGIN

@interface MediaCustomFullScreenVideoAdapterDelegate : NSObject<BUNativeExpressFullscreenVideoAdDelegate>
@property(nonatomic,assign)BOOL isAdValid;
@property(nonatomic,weak)id<MSCustomFullScreenVideoEventProtocol>event;
@end

NS_ASSUME_NONNULL_END
