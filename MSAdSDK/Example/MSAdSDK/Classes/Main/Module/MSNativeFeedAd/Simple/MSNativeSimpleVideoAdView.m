//
//  MSNativeSimpleVideoAdView.m
//  MSAdSDKDev
//
//  Created by leej on 2023/4/18.
//  Copyright © 2023 Adxdata. All rights reserved.
//

#import "MSNativeSimpleVideoAdView.h"
#import "UIImageView+WebCache.h"
#import "MediaCustomFeedVideoView.h"
//#import "MediaCustomHRFeedVideoView.h"

@interface MSNativeSimpleVideoAdView ()
@property (nonatomic,strong) UIImageView *interactionImageView;
@end

@implementation MSNativeSimpleVideoAdView

- (instancetype)initWithFeedAdMeta:(id<MSFeedAdMeta>)feedAdMeta
{
    self = [super init];
    if (self) {
        //第一步 设置广告容器frame
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [self calculateAdHeightWithFeedAdMeta:feedAdMeta]);
        //第二步 创建广告元素子控件并添加内容
        UIButton *closeBtn = [self createCloseBtn];
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
            sourceLabel.textColor = UIColor.orangeColor;
            sourceLabel.font = [UIFont systemFontOfSize:13];
        }
        UILabel *contentLabel = nil;
        if (feedAdMeta.metaContent.length > 0) {
            contentLabel = [self createAdLabel];
            contentLabel.text = feedAdMeta.metaContent;
            contentLabel.font = [UIFont systemFontOfSize:13];
            contentLabel.numberOfLines = 2;
        }
        /**
         第三步 将广告元素子控件传入 内部会把传入的子控件添加到容器中 媒体无需再次添加
         MSFeedVideoConfig为视频控制参数
         将广告元素子控件传入后（即调用loadNativeCustomVideoAdViewWithFrame方法后）内部自动创建播放器，媒体可通过self.videoView获取播放器控件
         */
        MSFeedVideoConfig *config = [[MSFeedVideoConfig alloc]init];
        config.isMute = YES;
        config.isAutoPlay = YES;
        [self loadNativeCustomVideoAdViewWithFrame:self.frame feedAdMeta:feedAdMeta metaLogo:feedAdMeta.metaLogo closeBtn:closeBtn videoConfig:config iconImageView:iconImageView actionLabel:actionLabel titleLabel:titleLabel sourceLabel:sourceLabel contentLabel:contentLabel];
        /**
         如媒体使用的是自定义平台，请在此处将播放器传入
         注意⚠️：媒体未使用自定义平台，忽略这一步
         */
//        if (feedAdMeta.metaPlatform == MSPlatformCP) {
//            if ([feedAdMeta.metaCustomPlatformIdentifier isEqualToString:@"HR"]) {
//                MediaCustomHRFeedVideoView *customFeedVideoView = [[MediaCustomHRFeedVideoView alloc]initWithFrame:self.bounds];
//                [self setMediaCustomFeedVideoView:customFeedVideoView];
//            } else {
//                MediaCustomFeedVideoView *customFeedVideoView = [[MediaCustomFeedVideoView alloc]initWithFrame:self.bounds];
//                [self setMediaCustomFeedVideoView:customFeedVideoView];
//            }
//        }
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
                self.interactionImageView = interactionImageView;
            }
        }
    }
    return self;
}
- (void)layoutNativeCustomImageAdViewSubViews{
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
            make.top.mas_equalTo(self).offset(10);
        }];
    }
    if (self.metaContentLabel) {
        [self.metaContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImageView ? self.iconImageView.mas_right : self).offset(20);
            make.right.mas_lessThanOrEqualTo(self.closeBtn.mas_left).offset(-10);
            make.top.mas_equalTo(self.metaTitleLabel ? self.metaTitleLabel.mas_bottom : self).offset(10);
        }];
    }
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.bottom.mas_equalTo(self).offset(-40);
    }];
    if (self.metaSourceLabel) {
        [self.metaSourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_lessThanOrEqualTo(100);
            make.left.mas_equalTo(self).offset(20);
            make.top.mas_equalTo(self.videoView.mas_bottom).offset(10);
        }];
    }
    if (self.metaActionLabel) {
        [self.metaActionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.metaSourceLabel ? self.metaSourceLabel.mas_right : self).offset(20);
            make.top.mas_equalTo(self.videoView.mas_bottom).offset(10);
            make.right.mas_lessThanOrEqualTo(self).offset(-20);
        }];
    }
    [self.videoView layoutIfNeeded];
    /**
     设置logo位置
     1、为兼容三方广告logo 一致通过setMetaLogoFrame设置
     2、logo是添加videoView上的 设置LogoFrame时，以videoView为参考
     */
    [self.feedAdData setMetaLogoFrame:CGRectMake(self.videoView.bounds.size.width - 40, self.videoView.bounds.size.height-15, 40, 15)];
}
//获取广告容器总高度，需媒体自行计算高度
-(CGFloat)calculateAdHeightWithFeedAdMeta:(id<MSFeedAdMeta>)feedAdMeta{
    CGFloat height = 350;
    return height;
}
//获取图片
- (void)showImage:(UIImageView *)imageView url:(NSString *)url {
    if (!imageView || url.length < 0) {
        return;
    }
    __block NSURL *iconURL = [NSURL URLWithString:url];
    __block UIImageView *view = imageView;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *iconData = [NSData dataWithContentsOfURL:iconURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:iconData];
            view.image = image;
        });
    });
}
//获取可点击的子控件，媒体自行指定
- (NSArray<UIView *>*)customVideoAdViewClickViews{
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
    [clickArr addObject:self.videoView];
    return clickArr.copy;
}
- (void)closeAd{
    if ([self.delegate respondsToSelector:@selector(nativeSimpleVideoAdViewClosed:)]) {
        [self.delegate nativeSimpleVideoAdViewClosed:self];
    }
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
