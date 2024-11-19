//
//  MSNativeSimpleVideoAdView.h
//  MSAdSDKDev
//
//  Created by leej on 2023/4/18.
//  Copyright © 2023 Adxdata. All rights reserved.
//

#import <MSAdSDK/MSNativeCustomVideoAdView.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MSNativeSimpleVideoAdViewDelegate <NSObject>

-(void)nativeSimpleVideoAdViewClosed:(MSNativeCustomVideoAdView *)adView;

@end
@interface MSNativeSimpleVideoAdView : MSNativeCustomVideoAdView
@property(nonatomic,weak)UIViewController *presentVc;
@property(nonatomic,weak)id<MSNativeSimpleVideoAdViewDelegate> delegate;
- (instancetype)initWithFeedAdMeta:(id<MSFeedAdMeta>)feedAdMeta;
- (NSArray<UIView *>*)customVideoAdViewClickViews;
- (void)switchInteractionIcon;
@end

NS_ASSUME_NONNULL_END
