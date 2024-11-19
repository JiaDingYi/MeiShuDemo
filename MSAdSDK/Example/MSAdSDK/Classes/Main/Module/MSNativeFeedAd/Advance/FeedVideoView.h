//
//  FeedVideoView.h
//  Demo
//
//  Created by zzq on 2020/2/28.
//  Copyright © 2020 bwhx. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MSAdSDK/MSAdSDK.h>

@interface FeedVideoView : UIView <MSFeedVideoDelegate>

@property(nonatomic,strong) MSFeedVideoView *mediaView;
@property(nonatomic,assign) BOOL isMute;
@property(nonatomic,assign) BOOL isAutoPlay;
@property(nonatomic,strong) MSNativeFeedAdModel *nativeFeedAdModel;
/**
 *  构造方法
 *  详解：frame - banner 展示的位置和大小
 */
- (instancetype)initWithWidth:(CGFloat)width adPresentVc:(UIViewController*)adPresentVc;
/// 绑定数据
- (void)registerDataObject;
/// 解绑广告数据
- (void)unregisterDataObject;
//计算高度
+ (CGFloat)heightCellForRow:(id<MSFeedAdMeta>)adModel
                      width:(CGFloat)width;

@end
