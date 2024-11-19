//
//  MediaCustomFeedAdMeta.m
//  MSAdSDKDev
//
//  Created by leej on 2022/5/23.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MediaCustomFeedAdMeta.h"

@interface MediaCustomFeedAdMeta ()
@property(nonatomic,strong)KSNativeAdRelatedView *relatedView;
@end

@implementation MediaCustomFeedAdMeta
/**
 如果三方提供查询广告是否有效接口则用三方的，否则按照三方广告过期时长进行比较
 此处仅代码示例
 */
-(BOOL)isAdValid{
    NSTimeInterval currentTime = [[NSDate date]timeIntervalSince1970];
    CGFloat validTime = currentTime - self.loadSuccessTime;
    if (validTime > 0 && validTime <= 3600) {
        return YES;
    }
    return NO;
}
//自定义平台标识
-(NSString *)metaCustomPlatformIdentifier{
    return @"";
}
- (MSCreativeType)metaCreativeType{
    return self.creativeType;
}
- (NSString *)metaTitle{
    return self.title;
}
- (NSString *)metaContent{
    return self.content;
}
- (NSString *)metaIcon{
    return self.icon;
}
- (UIImageView *)metaLogo{
    return self.logo;
}
- (CGSize)metaMainImageSize{
    return self.mainImageSize;
}
- (NSArray<NSString *> *)metaImageUrls{
    return self.imageUrls;
}
- (NSString *)metaVideoUrl{
    return self.videoUrl;
}
- (NSTimeInterval)metaVideoDuration{
    return self.videoDuration;
}
//广告交互类型(0:网页跳转,1:下载) 默认 值:0
- (NSInteger)metaTargetType{
    return self.targetType;
}
- (NSString *)metaFromId{
    return nil;
}
//广告物料归属平台 此处传入MSPlatformCP即可
- (MSPlatform)metaPlatform{
    return MSPlatformCP;
}
//引导语[立即下载、查看详情等]
- (NSString *)metaActionTitle{
    return self.actionTitle;
}
-(NSString *)metaSource{
    return self.source;
}
- (NSString * _Nullable)metaAdxName {
    return self.adxName;
}
- (NSString * _Nullable)metaAppCommentNum {
    return self.appCommentNum;
}
- (NSString * _Nullable)metaAppDownloadCountDesc {
    return self.appDownloadCountDesc;
}
- (NSString * _Nullable)metaAppPrice {
    return self.appPrice;
}
- (NSString * _Nullable)metaAppScore {
    return self.appScore;
}
- (NSString * _Nullable)metaAppSize {
    return self.appSize;
}
#pragma mark- Action
/**
 设置logo frame 绑定事件前传入
 注意：frame设置不要超出展示广告容器frame范围，否则可能展示不出logo
 */
- (void)setMetaLogoFrame:(CGRect)frame{
    self.logo.frame = frame;
}
/**
 隐藏广告logo及品牌logo
 调用时机：attachAd前
 注意：视频类型广告隐藏logo也是通过该方法
 */
- (void)hiddenAdLogo{
    self.logo.hidden = YES;
}
/**
 绑定子控件【使用sigmob自渲染广告该方法必须调用】
 调用时机：attachAd前
 注意：
 1、仅sigmob平台调用该接口，传入的子控件将被添加到sigmob提供的容器上
 2、因为该方法内部会先将这些子控件从父view上移除后再添加到sigmob提供的容器上，
 考虑到媒体可能接入多家平台广告，在使用其他家平台广告进行渲染时务必保证子控件添加到父view上，
 建议在调用attachAd方法前做次检查
 @param container     广告容器         传入前设置好frame
 @param mainImageView 主图            传入前设置好frame
 @param iconImageView 广告icon        传入前设置好frame
 @param title         广告标题         传入前设置好frame
 @param CTAButton     交互类型按钮      传入前设置好frame
 @param logoFrame     广告logo frame
 @param closeBtnFrame 广告关闭按钮 frame
 */
- (void)renderWithContainer:(UIView *)container
                    mainImg:(UIImageView *)mainImageView
                    iconImg:(UIImageView *)iconImageView
                    adTitle:(UILabel *)title
                  descLabel:(UILabel *)descLabel
                  CTAButton:(UIButton *)CTAButton
                  logoFrame:(CGRect)logoFrame
              closeBtnFrame:(CGRect)closeBtnFrame{
    
}
-(void)attachAd:(UIView *)container
    renderViews:(NSArray<UIView *> *)renderSubViews
      clickView:(NSArray<UIView *> *)clickViews
      presentVc:(UIViewController *)presentVc{
    self.adSuperView = container;
    if (!self.relatedView) {
        self.relatedView = [[KSNativeAdRelatedView alloc]init];
    }
    UILabel *adView = self.relatedView.adLabel;
    [adView removeFromSuperview];
    adView.frame = CGRectMake(container.frame.size.width - 28, container.frame.size.height - 16, 28, 16);
    adView.textColor = [UIColor whiteColor];
    adView.backgroundColor = [UIColor grayColor];
    [container addSubview:adView];
    [self.logo removeFromSuperview];
    [container addSubview:self.logo];
    self.logo.frame = CGRectMake(container.frame.size.width - 56, container.frame.size.height - 16, 28, 16);
    [self.relatedView refreshData:self.thirdPlatformNativeData];
    self.thirdPlatformNativeData.rootViewController = presentVc;
    [self.thirdPlatformNativeData registerContainer:container withClickableViews:clickViews];
}
//解绑数据
- (void)unAttachAd{
    [self.thirdPlatformNativeData unregisterView];
}
/**
 检测图片是否是gif图
 需传入图片data，如果媒体需支持GIF图，请在该接口中自行做检测逻辑
 */
- (BOOL)checkMetaGifImageData:(NSData *)imageData{
    return NO;
}
- (void)attachAd:(UIView * _Nonnull)container renderViews:(NSArray<UIView *> * _Nonnull)renderSubViews clickView:(NSArray<UIView *> * _Nonnull)clickViews closeView:(UIView * _Nullable)closeView presentVc:(UIViewController * _Nonnull)presentVc { 
    self.adSuperView = container;
    if (!self.relatedView) {
        self.relatedView = [[KSNativeAdRelatedView alloc]init];
    }
    UILabel *adView = self.relatedView.adLabel;
    [adView removeFromSuperview];
    adView.frame = CGRectMake(container.frame.size.width - 28, container.frame.size.height - 16, 28, 16);
    adView.textColor = [UIColor whiteColor];
    adView.backgroundColor = [UIColor grayColor];
    [container addSubview:adView];
    [self.logo removeFromSuperview];
    [container addSubview:self.logo];
    self.logo.frame = CGRectMake(container.frame.size.width - 56, container.frame.size.height - 16, 28, 16);
    [self.relatedView refreshData:self.thirdPlatformNativeData];
    self.thirdPlatformNativeData.rootViewController = presentVc;
    [self.thirdPlatformNativeData registerContainer:container withClickableViews:clickViews];
}
- (MSAdInteractionType)metaAdInteractionType { 
    return MSAdInteractionNormalType;
}
- (UIImageView * _Nullable)metaShakeTwistImageView { 
    return nil;
}

@end
