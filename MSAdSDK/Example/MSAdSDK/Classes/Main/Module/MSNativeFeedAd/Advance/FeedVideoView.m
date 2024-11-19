//
//  FeedVideoView.m
//  Demo
//
//  Created by zzq on 2020/2/28.
//  Copyright © 2020 bwhx. All rights reserved.
//


#import "FeedVideoView.h"
#import <StoreKit/StoreKit.h>
#import "MSTools.h"
#import <UIImage+GIF.h>
#import <MSAdSDK/MSFeedVideoConfig.h>
#import "MediaCustomFeedVideoView.h"

@interface FeedVideoView()
@property(nonatomic,strong) UILabel *titleLabel;//标题
@property(nonatomic,strong) UILabel *contentLabel;//描述
@property(nonatomic,strong) UILabel *sourceLabel;//来源
@property(nonatomic,strong) UILabel *toast;
@property(nonatomic,strong) UIView *mediaViewContainer;
@property(nonatomic,weak) UIViewController *adPresentVc;
@property(nonatomic,strong) UIImageView *logoimageView;//logo
@property (nonatomic,strong) UIButton    *CTAButton;
@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UILabel *videoDurationLabel;//描述
@property(nonatomic,strong) MediaCustomFeedVideoView *customFeedVideoView;
@end

@implementation FeedVideoView

- (instancetype)initWithWidth:(CGFloat)width
                  adPresentVc:(UIViewController *)adPresentVc {
    if (self = [super initWithFrame:CGRectMake(0, 0, width, 100)]) {
        self.adPresentVc = adPresentVc;
        [self custemView];
    }
    return self;
}
- (void)custemView{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.titleLabel = [UILabel new];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.contentLabel = [UILabel new];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor = MSUIColorFromRGB(0x666666);
    self.contentLabel.font = [UIFont systemFontOfSize:11];
    self.sourceLabel = [UILabel new];
    self.sourceLabel.numberOfLines = 0;
    self.sourceLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    self.videoDurationLabel = [UILabel new];
    self.videoDurationLabel.numberOfLines = 0;
    self.videoDurationLabel.frame = CGRectMake(self.bounds.size.width-70, 5, 60, 20);
    [self addSubview:self.videoDurationLabel];
    self.videoDurationLabel.font = [UIFont systemFontOfSize:12];
    self.videoDurationLabel.textAlignment = NSTextAlignmentCenter;
    self.iconImageView = [[UIImageView alloc]init];
    self.CTAButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _CTAButton.backgroundColor = UIColor.whiteColor;
    [_CTAButton setTitleColor:UIColor.systemBlueColor forState:UIControlStateNormal];
    _CTAButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _CTAButton.layer.masksToBounds = YES;
    _CTAButton.layer.cornerRadius = 5;
    _CTAButton.layer.borderColor = UIColor.systemBlueColor.CGColor;
    _CTAButton.layer.borderWidth = 1;
}
-(void)customMediaView{
    MSFeedVideoConfig *config = [MSFeedVideoConfig new];
    config.isMute = self.isMute;
    config.isAutoPlay = self.isAutoPlay;
    MSFeedVideoView *mediaView = [[MSFeedVideoView alloc]initWithFrame:self.mediaViewContainer.bounds delegate:self config:config presentVc:self.adPresentVc];
    mediaView.delegate = self;
    self.mediaView = mediaView;
    self.logoimageView = self.nativeFeedAdModel.adMaterialMeta.metaLogo;
    [self.mediaViewContainer addSubview:mediaView];
}
-(void)registerDataObject{
    [self updateCustomView];
    if (self.nativeFeedAdModel.adMaterialMeta.metaPlatform == MSPlatformCP) {
        if (!self.customFeedVideoView) {
            self.customFeedVideoView = [[MediaCustomFeedVideoView alloc]initWithFrame:self.mediaView.bounds];
        }
        [self.mediaView setMediaCustomFeedVideoView:self.customFeedVideoView];
    }
    [self.mediaView registerDataObject:self.nativeFeedAdModel.adMaterialMeta
                        clickableViews:@[self]];
    [self.mediaView muteVideo:self.isMute];
    if (self.nativeFeedAdModel.adMaterialMeta.metaPlatform == MSPlatformKS ||self.nativeFeedAdModel.adMaterialMeta.metaPlatform == MSPlatformCP) {
        [self updateVideoDuration];
    }
    if (![self.nativeFeedAdModel isAdValid]) {
        self.toast = [[UILabel alloc]initWithFrame:self.bounds];
        self.toast.text = @"广告已过期，请重新拉取广告";
        self.toast.textColor = [UIColor blueColor];
        self.toast.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.toast];
    }else{
        [self.toast removeFromSuperview];
    }
}
-(void)unregisterDataObject{
    [self.mediaView unregisterDataObject];
}
- (void)updateCustomView{
    id<MSFeedAdMeta>adModel = self.nativeFeedAdModel.adMaterialMeta;
    self.titleLabel.text = adModel.metaTitle;
    self.contentLabel.text = adModel.metaContent;
    CGFloat textMargin = 10;
    CGFloat iconWidth  = adModel.metaIcon.length > 0? 50 : 0;
    CGFloat textWidth = self.frame.size.width - textMargin * 2 - iconWidth;
    CGSize titleSize = [MSTools getTextSize:adModel.metaTitle
                                      fontSize:13
                                  maxChatWidth:textWidth];
    CGSize contentSize = [MSTools getTextSize:adModel.metaContent
                                          fontSize:11
                                      maxChatWidth:textWidth];
    self.titleLabel.frame = CGRectMake(textMargin+iconWidth, 10, textWidth, titleSize.height);
    self.contentLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + 5, CGRectGetWidth(self.titleLabel.frame), contentSize.height);
    CGRect frame = CGRectMake(10, CGRectGetMaxY(self.contentLabel.frame) + 5, CGRectGetWidth(self.frame)-20, 190);
    if (adModel.metaIcon.length > 0) {
        [self showImage:self.iconImageView url:adModel.metaIcon];
        self.iconImageView.frame = CGRectMake(10, 5, 40, 40);
        self.iconImageView.layer.cornerRadius = 5;
        self.iconImageView.layer.masksToBounds = YES;
        [self addSubview:self.iconImageView];
        frame = CGRectMake(10, CGRectGetMaxY(self.iconImageView.frame) + 5, CGRectGetWidth(self.frame)-20, 190);
    }
    self.frame = CGRectMake(0, 0, self.frame.size.width, [FeedVideoView heightCellForRow:adModel width:self.frame.size.width]);
    if (self.mediaViewContainer.superview) {
        [self.mediaViewContainer removeFromSuperview];
    }
    if ([adModel.metaCustomPlatformIdentifier isEqualToString:@"sigmob"]) {
        frame = self.bounds;
    }
    self.mediaViewContainer = [[UIView alloc] initWithFrame:frame];
    [self addSubview:self.mediaViewContainer];
    if (adModel.metaActionTitle.length > 0) {
        [self.CTAButton setTitle:adModel.metaActionTitle forState:UIControlStateNormal];
        self.CTAButton.frame = CGRectMake(self.frame.size.width-70, self.frame.size.height-25, 60, 20);
        [self addSubview:self.CTAButton];
    }
    if (adModel.metaSource.length > 0) {
        self.sourceLabel.text = [NSString stringWithFormat:@"广告来源：%@",adModel.metaSource];
        self.sourceLabel.frame = CGRectMake(10, self.frame.size.height-25, 100, 20);
        [self addSubview:self.sourceLabel];
    }
    [self customMediaView];
}
- (void)showImage:(UIImageView *)imageView url:(NSString *)url {
    if (!imageView || url.length < 0) {
        return;
    }
    __block NSURL *iconURL = [NSURL URLWithString:url];
    __block UIImageView *view = imageView;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *iconData = [NSData dataWithContentsOfURL:iconURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            //图片加载成功后，检测图片是否是gif
            if ([self.nativeFeedAdModel.adMaterialMeta checkMetaGifImageData:iconData]) {
                //此处展示gif图仅用做调试，使用sd_imageWithGIFData这个接口展示gif，性能不好，开发者需自定义播放gif组件
                view.image = [UIImage sd_imageWithGIFData:iconData];
            }else{
                UIImage *image = [UIImage imageWithData:iconData];
                view.image = image;
            }
        });
    });
}
+ (CGFloat)heightCellForRow:(id<MSFeedAdMeta>)adModel width:(CGFloat)width {
    CGFloat textMargin = 10;
    CGFloat iconWidth  = adModel.metaIcon.length > 0? 50 : 0;
    CGFloat caHeight = adModel.metaActionTitle.length > 0 ? 20:0;
    CGFloat textWidth = width - textMargin * 2-iconWidth;
    CGSize titleSize = [MSTools getTextSize:adModel.metaTitle
                                    fontSize:13
                                maxChatWidth:textWidth];
    CGSize contentSize = [MSTools getTextSize:adModel.metaContent
                                      fontSize:11
                                  maxChatWidth:textWidth];
    return titleSize.height + contentSize.height + 190 + 25 +caHeight+20;
}
-(void)updateVideoDuration{
    [self bringSubviewToFront:self.videoDurationLabel];
    if (!self.videoDurationLabel.text) {
        self.videoDurationLabel.text = [NSString stringWithFormat:@"总时长%lds",(long)[self.mediaView totalTime]];
    }
}
- (void)msFeedVideoFinish {
    NSLog(@"DEMO ADEVENT 信息流视频播放完成");
}
- (void)msFeedVideoStart {
    [self updateVideoDuration];
    NSLog(@"DEMO ADEVENT 信息流视频播放开始");
}
- (void)msFeedVideoPause {
    NSLog(@"DEMO ADEVENT 信息流视频播放暂停");
}
- (void)msFeedVideoError:(NSError *)error {
    NSLog(@"DEMO ADEVENT 信息流视频播放失败");
}
- (void)msFeedVideoResume{
    NSLog(@"DEMO ADEVENT 信息流视频恢复播放");
}
-(void)dealloc{
    [self unregisterDataObject];
}
@end
