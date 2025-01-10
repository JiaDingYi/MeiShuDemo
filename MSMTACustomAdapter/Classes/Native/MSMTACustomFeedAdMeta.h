//
//  MSMTACustomFeedAdMeta.h
//  MSMTACustomAdapter
//
//  Created by jdy on 2025/1/9.
//

#import <Foundation/Foundation.h>
#import <MSAdSDK/MSAdSDK.h>
#import <MentaUnifiedSDK/MentaUnifiedSDK-umbrella.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSMTACustomFeedAdMeta : NSObject <MSFeedAdMeta>

//类型
@property(nonatomic,assign)MSCreativeType creativeType;
//标题
@property(nonatomic,copy)NSString *title;
//内容
@property(nonatomic,copy)NSString *content;
//广告图标
@property(nonatomic,copy)NSString *icon;
//广告来源
@property(nonatomic,copy)NSString *source;
//adxName
@property(nonatomic,copy)NSString *adxName;
//应用评论数
@property(nonatomic,copy)NSString *appCommentNum;
//应用下载数
@property(nonatomic,copy)NSString *appDownloadCountDesc;
//应用价格
@property(nonatomic,copy)NSString *appPrice;
//应用评分
@property(nonatomic,copy)NSString *appScore;
//应用大小
@property(nonatomic,copy)NSString *appSize;
//平台Logo
@property(nonatomic,strong)UIImageView *logo;
//主图图片尺寸
@property(nonatomic,assign)CGSize mainImageSize;
//多图信息流
@property(nonatomic,strong)NSArray<NSString *> *imageUrls;
//信息流视频
@property(nonatomic,copy)NSString *videoUrl;
//视频时长
@property(nonatomic,assign)NSTimeInterval videoDuration;
//广告交互类型(0:网页跳转,1:下载) 默认 值:0
@property(nonatomic,assign)NSInteger targetType;
//引导语[立即下载、查看详情等]
@property(nonatomic,copy)NSString *actionTitle;
//加载成功时间戳 s
@property(nonatomic,assign)CGFloat loadSuccessTime;
//三方的广告物料对象，必须设置
@property(nonatomic,strong)MentaNativeObject *thirdPlatformNativeData;
@property(nonatomic,weak)UIView *adSuperView;

@end

NS_ASSUME_NONNULL_END
