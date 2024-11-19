//
//  MSSplashSettingView.h
//  MSAdSDKDev
//
//  Created by lj on 2021/4/9.
//  Copyright © 2021 Adxdata. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MSSplashSettingViewDelegate <NSObject>
@optional
-(void)loadAndShowSplash:(BOOL)open;
-(void)showSkipViewBtnClick:(BOOL)open;
-(void)adjustBottomViewHeight:(CGFloat)height;
-(void)openThirdBtnClick:(BOOL)open;
-(void)hideSkipBtnClick:(BOOL)open;
@end

@interface MSSplashSettingView : UIView
@property(nonatomic,weak)id<MSSplashSettingViewDelegate> delegate;
@property(nonatomic,assign)BOOL loadAndShow;
@property(nonatomic,assign)BOOL showSkipView;
@property(nonatomic,assign)BOOL openThirdWords;
@property(nonatomic,assign)BOOL hideSkipView;
@property(nonatomic,assign)BOOL denyCat;
@property(nonatomic,assign)BOOL denyCid;
@property(nonatomic,assign)BOOL denyAderId;
@property(nonatomic,assign)CGFloat bottomHeight;
@property(nonatomic,assign)NSInteger timeOut;
@end

NS_ASSUME_NONNULL_END
