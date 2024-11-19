//
//  MediaCustomFeedVideoView.m
//  MSAdSDKDev
//
//  Created by leej on 2022/5/23.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MediaCustomFeedVideoView.h"
#import "MediaCustomFeedAdMeta.h"

@interface MediaCustomFeedVideoView ()
@property(nonatomic,weak)id<MSFeedVideoDelegate>delegate;
@property(nonatomic,weak)UIViewController *presentVC;
@property(nonatomic,strong)MediaCustomFeedAdMeta *data;
@property(nonatomic,strong)KSNativeAdRelatedView *relatedView;
@property(nonatomic,strong)KSVideoAdView *videoView;

@end

@implementation MediaCustomFeedVideoView

- (void)registerDataObject:(id<MSFeedAdMeta>)dataObject
            clickableViews:(NSArray<UIView *>*)clickableViews{
    if ([dataObject isKindOfClass:[MediaCustomFeedAdMeta class]]) {
        self.data = (MediaCustomFeedAdMeta *)dataObject;
        self.data.thirdPlatformNativeData.rootViewController = self.presentVC;
        UILabel *adView = self.relatedView.adLabel;
        [adView removeFromSuperview];
        adView.frame = CGRectMake(self.frame.size.width - 28, self.frame.size.height - 16, 28, 16);
        adView.textColor = [UIColor grayColor];
        adView.backgroundColor = [UIColor clearColor];
        [self addSubview:adView];
        UIImageView *logo = self.data.logo;
        [logo removeFromSuperview];
        [self addSubview:logo];
        logo.frame = CGRectMake(self.frame.size.width - 56, self.frame.size.height - 16, 28, 16);
        [self.relatedView refreshData:self.data.thirdPlatformNativeData];
        [self.data.thirdPlatformNativeData registerContainer:self withClickableViews:clickableViews];
    }
}
-(void)unregisterDataObject{
    [self.data.thirdPlatformNativeData unregisterView];
}
-(void) config:(MSFeedVideoConfig*)config
     presentVc:(UIViewController*)presentVc
      delegate:(id<MSFeedVideoDelegate>)delegate{
    self.delegate = delegate;
    self.presentVC = presentVc;
    if (!self.relatedView) {
        self.relatedView = [[KSNativeAdRelatedView alloc]init];
    }
    self.videoView = self.relatedView.videoAdView;
    self.videoView.frame = self.frame;
    [self addSubview:self.videoView];
}
- (void)playVideo{
    
}
- (void)pauseVideo{
    
}
- (void)muteVideo:(BOOL)isMute{
    
}
- (void)replayVideo{
    
}
/**
 * 视频广告时长，单位 s
 */
- (CGFloat)totalTime{
    return self.data.videoDuration;
}
/**
 * 视频广告已播放时长，单位 s
 */
- (CGFloat)currentTime{
    return 0;
}
#pragma mark <三方播放器回调>
/**
 msFeedVideoPause仅演示使用，如果三方播放器有回调请替换成三方回调
 */
-(void)msFeedVideoPause{
    //此处一定要回调给mssdk内部
    if ([self.delegate respondsToSelector:@selector(msFeedVideoPause)]) {
        [self.delegate msFeedVideoPause];
    }
}
/**
 msFeedVideoStart仅演示使用，如果三方播放器有回调请替换成三方回调
 */
-(void)msFeedVideoStart{
    //此处一定要回调给mssdk内部
    if ([self.delegate respondsToSelector:@selector(msFeedVideoStart)]) {
        [self.delegate msFeedVideoStart];
    }
}
/**
 msFeedVideoFinish仅演示使用，如果三方播放器有回调请替换成三方回调
 */
-(void)msFeedVideoFinish{
    //此处一定要回调给mssdk内部
    if ([self.delegate respondsToSelector:@selector(msFeedVideoFinish)]) {
        [self.delegate msFeedVideoFinish];
    }
}
/**
 msFeedVideoError仅演示使用，如果三方播放器有回调请替换成三方回调
 */
-(void)msFeedVideoError:(NSError *)error{
    //此处一定要回调给mssdk内部
    if ([self.delegate respondsToSelector:@selector(msFeedVideoError:)]) {
        [self.delegate msFeedVideoError:error];
    }
}
@end
