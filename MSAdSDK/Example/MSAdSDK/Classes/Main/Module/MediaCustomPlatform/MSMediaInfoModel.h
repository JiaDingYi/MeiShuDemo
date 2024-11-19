//
//  MSMediaInfoModel.h
//  MSAdSDKDev
//
//  Created by leej on 2022/9/18.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSMediaInfoModel : NSObject
@property(nonatomic,copy)NSString *appid;//固定字段 不可修改
@property(nonatomic,copy)NSString *pid;//固定字段 不可修改
@property(nonatomic,copy)NSString *app_key;//媒体自定义字段
@property(nonatomic,copy)NSString *unit_id;//媒体自定义字段
- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
