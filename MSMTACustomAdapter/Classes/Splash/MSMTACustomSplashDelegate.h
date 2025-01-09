//
//  MSMTACustomSplashDelegate.h
//  MSMTACustomAdapter
//
//  Created by jdy on 2025/1/9.
//

#import <Foundation/Foundation.h>
#import <MSADSDK/MSADSDK.h>
#import <MentaUnifiedSDK/MentaUnifiedSDK-umbrella.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSMTACustomSplashDelegate : NSObject <MentaUnifiedSplashAdDelegate>

@property (nonatomic,weak) id<MSCustomSplashEventProtocol>reporter;
@property (nonatomic, assign, readonly) double ecpm;
@property (nonatomic, assign, readonly) BOOL isReady;

@end

NS_ASSUME_NONNULL_END
