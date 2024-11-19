//
//  MediaCustomPrerenderAdapterDelegate.h
//  MSAdSDKDev
//
//  Created by leej on 2022/5/20.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUAdSDK.h>
#import <MSAdSDK/MSCustomPrerenderEventProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface MediaCustomPrerenderAdapterDelegate : NSObject<BUNativeExpressAdViewDelegate>
@property(nonatomic,weak)UIViewController *presentVC;
@property(nonatomic,weak)id<MSCustomPrerenderEventProtocol> event;
@end

NS_ASSUME_NONNULL_END
