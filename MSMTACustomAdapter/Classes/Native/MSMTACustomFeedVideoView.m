//
//  MSMTACustomFeedVideoView.m
//  MSMTACustomAdapter
//
//  Created by jdy on 2025/1/10.
//

#import "MSMTACustomFeedVideoView.h"
#import "MSMTACustomFeedAdMeta.h"
#import <MentaUnifiedSDK/MentaUnifiedSDK-umbrella.h>

@interface MSMTACustomFeedVideoView ()

@property (nonatomic, weak) id<MSFeedVideoDelegate>delegate;
@property (nonatomic, weak) UIViewController *presentVC;
@property (nonatomic, strong) MSMTACustomFeedAdMeta *data;
@property (nonatomic, strong) UIView<MentaNativeAdViewProtocol> *nativeView;
@property (nonatomic, strong) UIView<MentaNativeAdMediaViewProtocol> *videoView;

@end

@implementation MSMTACustomFeedVideoView

- (void)registerDataObject:(id<MSFeedAdMeta>)dataObject
            clickableViews:(NSArray<UIView *>*)clickableViews {
    if ([dataObject isKindOfClass:[MSMTACustomFeedAdMeta class]]) {
        self.data = (MSMTACustomFeedAdMeta *)dataObject;
        self.nativeView = self.data.thirdPlatformNativeData.nativeAdView;
        if (self.superview) {
            self.nativeView.frame = self.superview.frame;
            [self.superview insertSubview:self.nativeView atIndex:0];
        } else {
            self.nativeView.frame = self.frame;
            [self insertSubview:self.nativeView atIndex:0];
        }
        
        self.videoView = self.nativeView.mentaMediaView;
        self.videoView.frame = self.frame;
        [self.nativeView addSubview:self.videoView];
        
        UIImageView *logo = self.data.logo;
        [logo removeFromSuperview];
        [self addSubview:logo];
        logo.frame = CGRectMake(self.frame.size.width - 32, self.frame.size.height - 16, 16, 16);
        [self.data.thirdPlatformNativeData registerClickableViews:clickableViews closeableViews:@[]];
    }
}

-(void)unregisterDataObject {
    
}

-(void) config:(MSFeedVideoConfig*)config
     presentVc:(UIViewController*)presentVc
      delegate:(id<MSFeedVideoDelegate>)delegate {
    self.delegate = delegate;
    self.presentVC = presentVc;
}

- (void)playVideo {
    [self.videoView play];
}

- (void)pauseVideo {
    [self.videoView pause];
}

- (void)muteVideo:(BOOL)isMute {
    [self.videoView muteEnable:isMute];
}

- (void)replayVideo {
    [self.videoView stop];
    [self.videoView play];
}
/**
 * 视频广告时长，单位 s
 */
- (CGFloat)totalTime {
    return self.data.thirdPlatformNativeData.dataObject.videoDuration;
}
/**
 * 视频广告已播放时长，单位 s
 */
- (CGFloat)currentTime {
    return self.videoView.videoPlayTime;
}
/**
 当外部需要再次更新播放器size后需调用该接口通知内部
 调用时机：绑定事件（即调用registerDataObject接口）之后调用
 */
- (void)resizeAdVideo:(CGSize)adsize {
    
}

/**
 绑定子控件【使用特殊平台自渲染广告该方法必须调用】
 调用时机：registerDataObject前
 ⚠️注意：
 1、仅特殊平台调用该接口，传入的子控件将被添加到特殊平台提供的容器上
 2、因为该方法内部会先将这些子控件从父view上移除后再添加到特殊平台提供的容器上，
 考虑到媒体可能接入多家平台广告，在使用其他家平台广告进行渲染时务必保证子控件添加到父view上，
 建议在调用registerDataObject方法前做次检查
 @param iconImageView 广告icon       传入前设置好frame
 @param title         广告标题        传入前设置好frame
 @param CTAButton     交互类型按钮     传入前设置好frame
 @param logoFrame     广告logo frame
 @param closeBtnFrame 广告关闭按钮 frame
 @param playerFrame   广告播放器 frame
 */
- (void)renderWithIconImg:(UIImageView *)iconImageView
                  adTitle:(UILabel *)title
                descLabel:(UILabel *)descLabel
                CTAButton:(UIButton *)CTAButton
                logoFrame:(CGRect)logoFrame
            closeBtnFrame:(CGRect)closeBtnFrame
              playerFrame:(CGRect)playerFrame
               dataObject:(id<MSFeedAdMeta>)dataObject
                container:(UIView *)container {
    
}

@end
