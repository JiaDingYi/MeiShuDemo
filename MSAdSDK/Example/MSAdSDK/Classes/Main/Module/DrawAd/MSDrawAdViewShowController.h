//
//  MSDrawAdViewShowController.h
//  MSAdSDKDev
//
//  Created by leej on 2023/5/5.
//  Copyright © 2023 Adxdata. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSDrawAdViewShowController : UIViewController
@property(nonatomic,assign) BOOL isMute;
@property(nonatomic,copy) void(^delegateBlock)(NSString *delegateInfo);
-(void)reloadAdDataSource:(NSArray<MSDrawAd *> *)dataSource;
@end

NS_ASSUME_NONNULL_END
