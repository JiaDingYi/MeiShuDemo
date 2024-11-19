//
//  MSNativeAdView.h
//  MSAdSDK
//
//  Created by yang on 2019/8/30.
//  Copyright © 2019 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSNativeAdView : UIView
/// 信息流广告类型
@property(nonatomic,assign)MSNativeAdType nativeAdViewShowType;
@property(nonatomic,strong)MSNativeFeedAdModel *nativeFeedAdModel;
/// 构造方法
/// @param frame 控件Frame
/// @param adPresentVc 展示广告的视图控制器
- (instancetype)initWithFrame:(CGRect)frame
                  adPresentVc:(UIViewController*)adPresentVc;
/// 绑定广告数据
-(void)registerDataObject;
/// 解绑广告数据   如果调用了registerDataObject:方法  一定要在适当的时机  调用unregisterDataObject方法
-(void)unregisterDataObject;
/// 获取视图大小
/// @param adModel 广告数据
/// @param nativeAdViewShowType 广告类型
+ (CGFloat)heightCellForRow:(id<MSFeedAdMeta>)adModel
       nativeAdViewShowType:(MSNativeAdType)nativeAdViewShowType;

@end
