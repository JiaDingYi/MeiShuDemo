//
//  MSMTACustomBannerDelegate.h
//  MSMTACustomAdapter
//
//  Created by jdy on 2025/1/9.
//

#import <Foundation/Foundation.h>
#import <MSAdSDK/MSAdSDK.h>
#import <MentaUnifiedSDK/MentaUnifiedSDK-umbrella.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSMTACustomBannerDelegate : NSObject <MentaUnifiedBannerAdDelegate>
@property (nonatomic, weak) id<MSCustomBannerEventProtocol> event;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, assign, readonly) double ecpm;
@property (nonatomic, assign, readonly) BOOL isReady;

@end

NS_ASSUME_NONNULL_END
