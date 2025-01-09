//
//  MSMTACustomInterstitialDelegate.h
//  MSMTACustomAdapter
//
//  Created by jdy on 2025/1/9.
//

#import <Foundation/Foundation.h>
#import <MentaUnifiedSDK/MentaUnifiedSDK-umbrella.h>
#import <MSAdSDK/MSAdSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSMTACustomInterstitialDelegate : NSObject <MentaUnifiedInterstitialAdDelegate>

@property (nonatomic, weak) id<MSCustomInterstitialEventProtocol>event;
@property (nonatomic, assign, readonly) double ecpm;
@property (nonatomic, assign, readonly) BOOL isReady;

@end

NS_ASSUME_NONNULL_END
