//
//  MSBaseAdViewController.h
//  MSAdSDKDev
//
//  Created by Liumaos on 2020/7/17.
//  Copyright © 2020 XiXiHaha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IdProviderFactory.h"


NS_ASSUME_NONNULL_BEGIN

@interface MSBaseAdViewController : UIViewController
@property(nonatomic,copy) NSString *defaultPid;
@property(nonatomic,copy) MSPlatformName platform;
@property(nonatomic,assign) MSAdType adType;
@property(nonatomic,assign)NSTimeInterval loadTime;
@property(nonatomic,assign)NSTimeInterval loadSuccessTime;
- (void)showAlert:(NSDictionary *)alertDict;
- (void)addDelegateString:(NSString *)str;
/**
 竞价成功上报
 此处模拟竞价成功示例
 */
-(void)sendWinNotificationWithInfo:(NSDictionary *)adInfo adLoader:(id)adLoader;
/**
 竞价失败上报
 此处模拟竞价成功示例
 */
-(void)sendLossNotificationWithInfo:(NSDictionary *)adInfo adLoader:(id)adLoader;
@end

NS_ASSUME_NONNULL_END
