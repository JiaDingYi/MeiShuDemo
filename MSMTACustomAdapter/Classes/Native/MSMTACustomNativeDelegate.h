//
//  MSMTACustomNativeDelegate.h
//  MSMTACustomAdapter
//
//  Created by jdy on 2025/1/9.
//

#import <Foundation/Foundation.h>
#import <MSAdSDK/MSAdSDK.h>
#import <MentaUnifiedSDK/MentaUnifiedSDK-umbrella.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSMTACustomNativeDelegate : NSObject <MentaUnifiedNativeAdDelegate>

@property (nonatomic,weak) id<MSCustomNativeEventProtocol> event;
@property (nonatomic,weak) UIViewController *presentVC;
@property (nonatomic,assign) double ecpm;

@end

NS_ASSUME_NONNULL_END
