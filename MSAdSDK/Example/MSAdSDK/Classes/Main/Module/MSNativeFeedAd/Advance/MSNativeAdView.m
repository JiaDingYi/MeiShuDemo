//
//  MSNativeAdView.m
//  MSAdSDK
//
//  Created by yang on 2019/8/30.
//  Copyright © 2019 yang. All rights reserved.
//

#import "MSNativeAdView.h"
#import <StoreKit/StoreKit.h>
#import "MSTools.h"
#import <UIImage+GIF.h>

@interface MSNativeAdView()
@property(nonatomic,weak) UIViewController*adPresentVc; //展示广告详情页的控制器
@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UILabel *contentLabel;//描述
@property(nonatomic,strong) UILabel *sourceLabel;//来源
@property (nonatomic, strong) UIImageView *imageView;//大图/一图
@property (nonatomic, strong) UIImageView *imageView2;//二图
@property (nonatomic, strong) UIImageView *imageView3;//三图
@property (nonatomic, strong) UILabel *actionButton;//按钮
@property (nonatomic,strong) UIButton *CTAButton;
@property(nonatomic,strong) UILabel *toast;
@property (nonatomic, strong) UIImageView *logoimageView;//logo
@end

@implementation MSNativeAdView
- (instancetype)initWithFrame:(CGRect)frame adPresentVc:(UIViewController *)adPresentVc{
    if (self = [super initWithFrame:frame]) {
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
    self.actionButton = [UILabel new];
    self.actionButton.text = @"下载";
    self.actionButton.font = [UIFont systemFontOfSize:11];
    self.actionButton.textColor = UIColor.systemBlueColor;
    self.actionButton.layer.masksToBounds = YES;
    self.actionButton.layer.cornerRadius = 5;
    self.actionButton.layer.borderColor = UIColor.systemBlueColor.CGColor;
    self.actionButton.layer.borderWidth = 1;
    self.actionButton.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.sourceLabel];
    self.imageView = [self createImage];
    [self addSubview:self.actionButton];
    self.CTAButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _CTAButton.backgroundColor = UIColor.whiteColor;
    [_CTAButton setTitleColor:UIColor.systemBlueColor forState:UIControlStateNormal];
    _CTAButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _CTAButton.layer.masksToBounds = YES;
    _CTAButton.layer.cornerRadius = 5;
    _CTAButton.layer.borderColor = UIColor.systemBlueColor.CGColor;
    _CTAButton.layer.borderWidth = 1;
}
-(void)updateUI{
    id<MSFeedAdMeta>adModel = self.nativeFeedAdModel.adMaterialMeta;
    self.titleLabel.text   = adModel.metaTitle;
    self.contentLabel.text = adModel.metaContent;
    if (adModel.metaImageUrls.count > 0) {
        [self showImage:self.imageView url:adModel.metaImageUrls[0]];
    }
    self.logoimageView = adModel.metaLogo;
    self.logoimageView.frame = CGRectMake(0, 0, 30, 20);
    if (adModel.metaTargetType == MSTargetTypeDetail) {
        self.actionButton.text = @"浏览";
    } else {
        self.actionButton.text = @"下载";
    }
    CGSize size = [UIScreen mainScreen].bounds.size;
    float screen_width =  size.width > size.height ? size.height : size.width;
    //    MSLeftImage= 0, // 展示左图右文+下载按钮
    //    MSLeftImageNoButton = 1, // 展示左图右文
    //    MSBottomImage = 2, // 展示上文下大图
    self.actionButton.hidden = YES;
    if (adModel.metaCreativeType == MSCreativeTypeSmallImage) {
        CGFloat imageWidth   = 100;
        CGFloat imageHeight  = 75;
        CGFloat textMaxWidth = self.frame.size.width - imageWidth - 20;
        CGFloat padding      = 10;
        CGSize titleSize =  [MSTools getTextSize:adModel.metaTitle
                                        fontSize:13
                                    maxChatWidth:textMaxWidth];
        CGSize contentSize =  [MSTools getTextSize:adModel.metaContent
                                          fontSize:11
                                      maxChatWidth:textMaxWidth];
        self.titleLabel.frame = CGRectMake(imageWidth + padding + 10, padding, textMaxWidth, titleSize.height);
        self.contentLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame)+20, CGRectGetWidth(self.titleLabel.frame), contentSize.height);
        if (_nativeAdViewShowType == MSNativeAdLeftImage) {
            self.actionButton.hidden = NO;
            self.frame = CGRectMake(0, 0, self.frame.size.width, imageHeight + padding * 2);
            self.actionButton.frame = CGRectMake(imageWidth+20, self.frame.size.height - 20, 30, 10);
        } else {
            self.frame = CGRectMake(0, 0, self.frame.size.width, imageHeight + padding * 2);
        }
        self.imageView.frame = CGRectMake(padding, padding, imageWidth, imageHeight);
        self.titleLabel.numberOfLines = 2;
        self.contentLabel.numberOfLines= 1;
    } else if (adModel.metaCreativeType == MSCreativeTypeLargeImage
               || adModel.metaCreativeType == MSCreativeTypeImage
               || adModel.metaCreativeType == MSCreativeTypeThreeImage) {
        self.imageView.userInteractionEnabled = NO;
        if (adModel.metaCreativeType == MSCreativeTypeLargeImage
            ||adModel.metaCreativeType == MSCreativeTypeImage) {
            CGFloat textMargin = 10;
            CGFloat iconWidth  = adModel.metaIcon.length > 0? 50 : 0;
            CGFloat textWidth  = self.frame.size.width - textMargin * 2 - iconWidth;
            CGSize titleSize   =  [MSTools getTextSize:adModel.metaTitle
                                              fontSize:13
                                          maxChatWidth:textWidth];
            CGSize contentSize =  [MSTools getTextSize:adModel.metaContent
                                              fontSize:11
                                          maxChatWidth:textWidth];
            self.titleLabel.frame   = CGRectMake(textMargin+iconWidth, 10, textWidth, titleSize.height);
            self.contentLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + 5, CGRectGetWidth(self.titleLabel.frame), contentSize.height);
            if (adModel.metaIcon.length > 0) {
                [self.imageView2 removeFromSuperview];
                self.imageView2 = [self createImage];
                [self showImage:self.imageView2 url:adModel.metaIcon];
                self.imageView2.frame = CGRectMake(10, 5, 40, 40);
            }
            self.frame = CGRectMake(0, 0, self.frame.size.width, CGRectGetMaxY(self.titleLabel.frame)+contentSize.height+5);
            self.imageView.frame = CGRectMake(10, CGRectGetMaxY(self.contentLabel.frame) + 5, self.frame.size.width-20, screen_width/2-20);
            CGRect frame = self.frame;
            CGFloat height = CGRectGetMaxY(self.contentLabel.frame);
            if (height < CGRectGetMaxY(self.imageView2.frame)) {
                height = CGRectGetMaxY(self.imageView2.frame);
                self.imageView.frame = CGRectMake(10, CGRectGetMaxY(self.imageView2.frame) + 5, self.frame.size.width-20, screen_width/2-20);
            }
            frame.size.height = height + self.imageView.frame.size.height+10;
            self.frame = frame;
        } else {
            CGFloat textMargin = 10;
            CGFloat textWidth  = self.frame.size.width - textMargin * 2;
            CGSize titleSize   =  [MSTools getTextSize:adModel.metaTitle
                                              fontSize:13
                                          maxChatWidth:textWidth];
            CGSize contentSize =  [MSTools getTextSize:adModel.metaContent
                                              fontSize:11
                                          maxChatWidth:textWidth];
            self.titleLabel.frame   = CGRectMake(textMargin, 10, textWidth, titleSize.height);
            self.contentLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + 5, CGRectGetWidth(self.titleLabel.frame), contentSize.height);
            self.frame = CGRectMake(0, 0, self.frame.size.width, CGRectGetMaxY(self.titleLabel.frame)+contentSize.height+5);
            NSInteger imageCount = adModel.metaImageUrls.count;
            CGFloat imageWidth = (self.frame.size.width - 10 * (imageCount + 1)) / imageCount;
            CGFloat imageHeight = ((screen_width - 10 * (imageCount + 1)) / imageCount) * 2 / 3;
            CGFloat imageY = CGRectGetMaxY(self.contentLabel.frame) + 5;
            self.imageView.frame = CGRectMake(10, imageY, imageWidth, imageHeight);
            if (imageCount > 1) {
                self.imageView2 = [self createImage];
                self.imageView2.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10, imageY, imageWidth, imageHeight);
                [self showImage:self.imageView2 url:adModel.metaImageUrls[1]];
            }
            if (imageCount > 2) {
                self.imageView3 = [self createImage];
                self.imageView3.frame = CGRectMake(CGRectGetMaxX(self.imageView2.frame) + 10, imageY, imageWidth, imageHeight);
                [self showImage:self.imageView3 url:adModel.metaImageUrls[2]];
            }
            CGRect frame = self.frame;
            frame.size.height = CGRectGetMaxY(self.contentLabel.frame) + imageHeight;
            self.frame = frame;
        }
    }
    if (adModel.metaSource.length > 0) {
        self.sourceLabel.text = [NSString stringWithFormat:@"广告来源：%@",adModel.metaSource];
        self.sourceLabel.frame = CGRectMake(10, self.frame.size.height+5, 160, 20);
        [self addSubview:self.sourceLabel];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height+25);
    }
    if (adModel.metaActionTitle.length > 0) {
        self.actionButton.hidden = NO;
        self.actionButton.text = adModel.metaActionTitle;
        CGFloat x = self.frame.size.width-70;
        CGFloat y = adModel.metaSource.length > 0 ? CGRectGetMinY(self.sourceLabel.frame) : self.frame.size.height+5;
        CGFloat tempH = adModel.metaSource.length > 0 ? 0 : 25;
        self.actionButton.frame = CGRectMake(x, y, 60, 20);
        [self addSubview:self.actionButton];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height+tempH);
    }
    if (adModel.metaSource.length > 0 || adModel.metaActionTitle.length > 0) {
        [adModel setMetaLogoFrame:CGRectMake(self.frame.size.width-50, CGRectGetMaxY(self.imageView.frame)-20, 40, 20)];
    }
}
-(void)registerDataObject{
    [self updateUI];
    if ([self.nativeFeedAdModel.adMaterialMeta.metaCustomPlatformIdentifier isEqualToString:@"sigmob"]) {
        [self.CTAButton setTitle:self.nativeFeedAdModel.adMaterialMeta.metaActionTitle forState:UIControlStateNormal];
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height + 25);
        self.CTAButton.frame = CGRectMake(self.frame.size.width-120, self.frame.size.height-20, 60, 20);
        [self.nativeFeedAdModel.adMaterialMeta renderWithContainer:self mainImg:self.imageView iconImg:self.imageView2 adTitle:self.titleLabel descLabel:self.contentLabel CTAButton:self.CTAButton logoFrame:CGRectMake(10, self.CTAButton.frame.origin.y, 40, 20) closeBtnFrame:CGRectMake(CGRectGetMaxX(self.CTAButton.frame)+15, self.CTAButton.frame.origin.y, 30, 20)];
    }
    NSMutableArray *tempArrM = [[NSMutableArray alloc]init];
    [tempArrM addObject:self.titleLabel];
    [tempArrM addObject:self.contentLabel];
    [tempArrM addObject:self.imageView];
    if (self.imageView2) {
        [tempArrM addObject:self.imageView2];
    }
    if (self.imageView3) {
        [tempArrM addObject:self.imageView3];
    }
    if (self.nativeFeedAdModel.adMaterialMeta.metaSource.length > 0) {
        [tempArrM addObject:self.sourceLabel];
    }
    if (self.nativeFeedAdModel.adMaterialMeta.metaActionTitle.length > 0) {
        [tempArrM addObject:self.actionButton];
    }
    //将广告与UIView进行绑定
    [self.nativeFeedAdModel.adMaterialMeta attachAd:self renderViews:tempArrM.copy clickView:tempArrM.copy closeView:nil presentVc:self.adPresentVc];
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
    [self.nativeFeedAdModel.adMaterialMeta unAttachAd];
}
-(void)layoutSubviews{
    [super layoutSubviews];
}
- (UIImageView *)createImage {
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode  =  UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    imageView.backgroundColor = [UIColor blackColor];
    return imageView;
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
- (void)setNativeAdViewShowType:(MSNativeAdType)nativeAdViewShowType{
    _nativeAdViewShowType =nativeAdViewShowType;
    [self custemView];
    [self updateUI];
}
+ (CGFloat)heightCellForRow:(id<MSFeedAdMeta>)adModel
       nativeAdViewShowType:(MSNativeAdType)nativeAdViewShowType{
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat  temp = 0;
    float screen_width =  size.width > size.height ? size.height : size.width;
    CGSize titleSize   =  [MSTools getTextSize:adModel.metaTitle
                                      fontSize:13
                                  maxChatWidth:screen_width/2-10];
    CGSize contentSize =  [MSTools getTextSize:adModel.metaContent
                                      fontSize:11
                                  maxChatWidth:screen_width/2-10];
    
    if(nativeAdViewShowType == MSNativeAdLeftImage || nativeAdViewShowType == MSNativeAdLeftImageNoButton) {
        CGFloat imageHeight = 75;
        return imageHeight + 20 + temp;
    } else if (nativeAdViewShowType == MSNativeAdBottomImage) {
        CGFloat textMargin = 20;
        CGFloat textWidth  = screen_width - textMargin * 2;
        titleSize   =  [MSTools getTextSize:adModel.metaTitle
                                   fontSize:13 maxChatWidth:textWidth];
        contentSize =  [MSTools getTextSize:adModel.metaContent fontSize:11
                               maxChatWidth:textWidth];
        if ([adModel.metaCustomPlatformIdentifier isEqualToString:@"sigmob"]) {
            return titleSize.height+contentSize.height+(screen_width/2-10) + 25 +30 + temp;
        }
        return titleSize.height+contentSize.height+(screen_width/2-10) + 45 + temp;
    } else if (nativeAdViewShowType == MSNativeAdThreeImage) {
        titleSize =  [MSTools getTextSize:adModel.metaTitle
                                 fontSize:13
                             maxChatWidth:screen_width-10];
        contentSize =  [MSTools getTextSize:adModel.metaContent
                                   fontSize:11
                               maxChatWidth:screen_width-10];
        NSInteger imageCount = adModel.metaImageUrls.count;
        CGFloat imageWidth   = (screen_width - 10 * (imageCount + 1)) / imageCount;
        CGFloat imageHeight  = imageWidth * 2 / 3;
        if (adModel.metaSource.length > 0 || adModel.metaActionTitle.length > 0) {
            temp = 25;
        }
        return titleSize.height + contentSize.height + imageHeight + 25 + temp;
    }
    return 0;
}

@end
