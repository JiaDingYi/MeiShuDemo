//
//  MSNativeSimpleImageAdView.h
//  MSAdSDKDev
//
//  Created by leej on 2023/4/18.
//  Copyright © 2023 Adxdata. All rights reserved.
//

#import <MSAdSDK/MSNativeCustomAdView.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MSNativeSimpleImageAdViewDelegate <NSObject>

-(void)nativeSimpleImageAdViewClosed:(MSNativeCustomAdView *)adView;

@end

@interface MSNativeSimpleImageAdView : MSNativeCustomAdView
@property(nonatomic,weak)UIViewController *presentVc;
@property(nonatomic,weak)id<MSNativeSimpleImageAdViewDelegate> delegate;
- (instancetype)initWithFeedAdMeta:(id<MSFeedAdMeta>)feedAdMeta;
- (NSArray<UIView *> *)customImageAdViewClickViews;
- (void)switchInteractionIcon;
@end

NS_ASSUME_NONNULL_END
