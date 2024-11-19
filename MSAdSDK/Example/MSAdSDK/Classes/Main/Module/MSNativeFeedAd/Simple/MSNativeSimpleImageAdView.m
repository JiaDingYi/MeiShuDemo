//
//  MSNativeSimpleImageAdView.m
//  MSAdSDKDev
//
//  Created by leej on 2023/4/18.
//  Copyright © 2023 Adxdata. All rights reserved.
//

#import "MSNativeSimpleImageAdView.h"
#import <UIImage+GIF.h>
#import "UIImageView+WebCache.h"

@interface MSNativeSimpleImageAdView ()
@property (nonatomic,strong) UIImageView *interactionImageView;
@end

@implementation MSNativeSimpleImageAdView

- (instancetype)initWithFeedAdMeta:(id<MSFeedAdMeta>)feedAdMeta
{
    self = [super init];
    if (self) {
        //第一步 设置广告容器frame
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [self calculateAdHeightWithFeedAdMeta:feedAdMeta]);
        //第二步 创建广告元素子控件并添加内容
        UIButton *closeBtn = [self createCloseBtn];
        NSMutableArray *imgArr = [[NSMutableArray alloc]init];
        if (feedAdMeta.metaCreativeType == MSCreativeTypeImage ||
            feedAdMeta.metaCreativeType == MSCreativeTypeLargeImage) {
            UIImageView *img = [self createImgView];
            [self showImage:img url:feedAdMeta.metaImageUrls.firstObject];
            [imgArr addObject:img];
        } else if (feedAdMeta.metaCreativeType == MSCreativeTypeSmallImage){
            UIImageView *img = [self createImgView];
            [self showImage:img url:feedAdMeta.metaImageUrls.firstObject];
            [imgArr addObject:img];
        } else if (feedAdMeta.metaCreativeType == MSCreativeTypeThreeImage){
            for (int index=0; index<feedAdMeta.metaImageUrls.count; index++) {
                UIImageView *img = [self createImgView];
                [imgArr addObject:img];
                [self showImage:img url:feedAdMeta.metaImageUrls[index]];
            }
        }
        UIImageView *iconImageView = nil;
        if (feedAdMeta.metaIcon.length > 0) {
            iconImageView = [self createImgView];
            [self showImage:iconImageView url:feedAdMeta.metaIcon];
            iconImageView.layer.masksToBounds = YES;
            iconImageView.layer.cornerRadius = 10;
        }
        UILabel *actionLabel = nil;
        if (feedAdMeta.metaActionTitle.length > 0) {
            actionLabel = [self createAdLabel];
            actionLabel.text = feedAdMeta.metaActionTitle;
            actionLabel.textColor = UIColor.orangeColor;
            actionLabel.layer.masksToBounds = YES;
            actionLabel.layer.cornerRadius = 5;
            actionLabel.layer.borderColor = UIColor.orangeColor.CGColor;
            actionLabel.layer.borderWidth = 1;
            actionLabel.textAlignment = NSTextAlignmentCenter;
            actionLabel.font = [UIFont systemFontOfSize:13];
        }
        UILabel *titleLabel = nil;
        if (feedAdMeta.metaTitle.length > 0) {
            titleLabel = [self createAdLabel];
            titleLabel.text = feedAdMeta.metaTitle;
            titleLabel.font = [UIFont systemFontOfSize:13];
            titleLabel.numberOfLines = 2;
        }
        UILabel *sourceLabel = nil;
        if (feedAdMeta.metaSource.length > 0) {
            sourceLabel = [self createAdLabel];
            sourceLabel.text = feedAdMeta.metaSource;
            sourceLabel.font = [UIFont systemFontOfSize:13];
            sourceLabel.textColor = UIColor.orangeColor;
        }
        UILabel *contentLabel = nil;
        if (feedAdMeta.metaContent.length > 0) {
            contentLabel = [self createAdLabel];
            contentLabel.text = feedAdMeta.metaContent;
            contentLabel.font = [UIFont systemFontOfSize:13];
            contentLabel.numberOfLines = 2;
        }
        //第三步 将广告元素子控件传入 内部会把传入的子控件添加到容器中 媒体无需再次添加
        [self loadNativeCustomAdWithFeedAdMeta:feedAdMeta metaLogo:feedAdMeta.metaLogo closeBtn:closeBtn imgViews:imgArr iconImageView:iconImageView actionLabel:actionLabel titleLabel:titleLabel sourceLabel:sourceLabel contentLabel:contentLabel];
        //第四步 布局广告元素子控件
        [self layoutNativeCustomImageAdViewSubViews];
        //第五步 添加交互按钮标识
        if ([feedAdMeta metaAdInteractionType] != MSAdInteractionNormalType) {
            UIImageView *interactionImageView = feedAdMeta.metaShakeTwistImageView;
            if (interactionImageView) {
                [self addSubview:interactionImageView];
                [interactionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self).offset(2);
                    make.bottom.mas_equalTo(self).offset(-10);
                    make.size.mas_equalTo(CGSizeMake(40, 15));
                }];
            }
            self.interactionImageView = interactionImageView;
        }
    }
    return self;
}
- (void)layoutNativeCustomImageAdViewSubViews{
    //设置logo位置(默认广告容器右下角) 为兼容三方广告logo 一致通过setMetaLogoFrame设置
    [self.feedAdData setMetaLogoFrame:CGRectMake(self.bounds.size.width - 60, self.bounds.size.height-20, 40, 15)];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-20);
        make.top.mas_equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    if (self.iconImageView) {
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(20);
            make.top.mas_equalTo(self).offset(10);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
    }
    if (self.metaTitleLabel) {
        [self.metaTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImageView ? self.iconImageView.mas_right : self).offset(20);
            make.right.mas_lessThanOrEqualTo(self.closeBtn.mas_left).offset(-10);
            if (self.feedAdData.metaContent.length > 0) {
                make.top.mas_equalTo(self).offset(10);
            } else if(self.iconImageView){
                make.centerY.mas_equalTo(self.iconImageView);
            } else {
                make.top.mas_equalTo(self).offset(10);
            }
        }];
    }
    if (self.metaContentLabel) {
        [self.metaContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImageView ? self.iconImageView.mas_right : self).offset(20);
            make.right.mas_lessThanOrEqualTo(self.closeBtn.mas_left).offset(-10);
            if (self.feedAdData.metaTitle.length > 0) {
                make.top.mas_equalTo(self.metaTitleLabel.mas_bottom).offset(10);
            } else if(self.iconImageView){
                make.centerY.mas_equalTo(self.iconImageView);
            } else {
                make.top.mas_equalTo(self).offset(10);
            }
        }];
    }
    if (self.feedAdData.metaCreativeType == MSCreativeTypeImage ||
        self.feedAdData.metaCreativeType == MSCreativeTypeLargeImage) {
        UIImageView *img = self.imgViews.firstObject;
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(20);
            make.right.mas_equalTo(self).offset(-20);
            if (self.iconImageView) {
                make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(10);
            } else if(self.metaContentLabel) {
                make.top.mas_equalTo(self.metaContentLabel.mas_bottom).offset(10);
            } else if(self.metaTitleLabel) {
                make.top.mas_equalTo(self.metaTitleLabel.mas_bottom).offset(10);
            }else {
                make.top.mas_equalTo(self).offset(10);
            }
            make.bottom.mas_equalTo(self).offset(-30);
        }];
    } else if (self.feedAdData.metaCreativeType == MSCreativeTypeSmallImage){
        self.iconImageView.hidden = YES;
        UIImageView *img = self.imgViews.firstObject;
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(20);
            make.width.mas_equalTo(100);
            make.top.mas_equalTo(self).offset(10);
            make.bottom.mas_equalTo(self).offset(-30);
        }];
        if (self.metaTitleLabel) {
            [self.metaTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(img.mas_right).offset(10);
                make.right.mas_equalTo(self).offset(-20);
                make.top.mas_equalTo(img);
            }];
        }
        if (self.metaContentLabel) {
            [self.metaContentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(img.mas_right).offset(10);
                make.right.mas_equalTo(self).offset(-20);
                if (self.metaTitleLabel) {
                    make.top.mas_equalTo(self.metaTitleLabel.mas_bottom);
                } else {
                    make.top.mas_equalTo(img);
                }
            }];
        }
    } else if (self.feedAdData.metaCreativeType == MSCreativeTypeThreeImage){
        if (self.imgViews.count >=2) {
            [self.imgViews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:20 tailSpacing:20];
            [self.imgViews mas_makeConstraints:^(MASConstraintMaker *make) {
                if (self.iconImageView) {
                    make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(10);
                } else if(self.metaContentLabel) {
                    make.top.mas_equalTo(self.metaContentLabel.mas_bottom).offset(10);
                } else if(self.metaTitleLabel) {
                    make.top.mas_equalTo(self.metaTitleLabel.mas_bottom).offset(10);
                }else {
                    make.top.mas_equalTo(self).offset(10);
                }
                make.height.mas_equalTo(100);
            }];
        } else if (self.imgViews.count == 1){
            UIImageView *img = self.imgViews.firstObject;
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self).offset(20);
                make.right.mas_equalTo(self).offset(-20);
                if (self.iconImageView) {
                    make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(10);
                } else if(self.metaContentLabel) {
                    make.top.mas_equalTo(self.metaContentLabel.mas_bottom).offset(10);
                } else if(self.metaTitleLabel) {
                    make.top.mas_equalTo(self.metaTitleLabel.mas_bottom).offset(10);
                }else {
                    make.top.mas_equalTo(self).offset(10);
                }
                make.bottom.mas_equalTo(self).offset(-30);
            }];
        }
    }
    if (self.metaSourceLabel) {
        [self.metaSourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(20);
            make.bottom.mas_equalTo(self).offset(-5);
            make.width.mas_lessThanOrEqualTo(100);
        }];
    }
    if (self.metaActionLabel) {
        [self.metaActionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.metaSourceLabel ? self.metaSourceLabel.mas_right : self).offset(20);
            make.bottom.mas_equalTo(self).offset(-5);
            make.width.mas_lessThanOrEqualTo(100);
        }];
    }
}
-(CGFloat)calculateAdHeightWithFeedAdMeta:(id<MSFeedAdMeta>)feedAdMeta{
    CGFloat height = 300;
    if (feedAdMeta.metaCreativeType == MSCreativeTypeThreeImage && feedAdMeta.metaImageUrls.count >= 2){
        height = 200;
        if (self.metaSourceLabel || self.metaActionLabel) {
            height += 30;
        }
    } else if (feedAdMeta.metaCreativeType == MSCreativeTypeSmallImage){
        height = 200;
    }
    return height;
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
            if ([self.feedAdData checkMetaGifImageData:iconData]) {
                //此处展示gif图仅用做调试，使用sd_imageWithGIFData这个接口展示gif，性能不好，开发者需自定义播放gif组件
                view.image = [UIImage sd_imageWithGIFData:iconData];
            }else{
                UIImage *image = [UIImage imageWithData:iconData];
                view.image = image;
            }
        });
    });
}
- (void)closeAd{
    if ([self.delegate respondsToSelector:@selector(nativeSimpleImageAdViewClosed:)]) {
        [self.delegate nativeSimpleImageAdViewClosed:self];
    }
}
- (NSArray<UIView *>*)customImageAdViewClickViews{
    NSMutableArray *clickArr = [[NSMutableArray alloc]init];
    if (self.iconImageView) {
        [clickArr addObject:self.iconImageView];
    }
    if (self.metaTitleLabel) {
        [clickArr addObject:self.metaTitleLabel];
    }
    if (self.metaContentLabel) {
        [clickArr addObject:self.metaContentLabel];
    }
    if (self.metaSourceLabel) {
        [clickArr addObject:self.metaSourceLabel];
    }
    if (self.metaActionLabel) {
        [clickArr addObject:self.metaActionLabel];
    }
    for (UIImageView *img in self.imgViews) {
        [clickArr addObject:img];
    }
    return clickArr.copy;
}
- (void)switchInteractionIcon{
    self.interactionImageView.hidden = [self.feedAdData metaAdInteractionType] == MSAdInteractionNormalType;
}
- (UIButton *)createCloseBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"close_btn_prerender"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(closeAd) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.textColor = UIColor.blackColor;
    return btn;
}
- (UIImageView *)createImgView{
    UIImageView *img = [[UIImageView alloc]init];
    return img;
}
- (UILabel *)createAdLabel{
    UILabel *label = [[UILabel alloc]init];
    return label;
}
-(void)dealloc{
   
}
@end
