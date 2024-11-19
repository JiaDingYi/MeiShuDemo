//
//  MSNativeTestModel.h
//  MSAdSDKDev
//
//  Created by leej on 2021/5/8.
//  Copyright © 2021 Adxdata. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,MSNativeTestModelType) {
    MSNativeTestModelNoImageType,
    MSNativeTestModelUpWordDownImageType,
    MSNativeTestModelLeftWordRightImageType,
    MSNativeTestModelLeftImageRightWordType
};
NS_ASSUME_NONNULL_BEGIN

@interface MSNativeTestModel : NSObject
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *desc;
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *nowTime;
@property(nonatomic,copy)NSString *contentType;
@property(nonatomic,copy)NSString *modelType;
- (instancetype)initWithDict:(NSDictionary *)dict;
- (CGFloat)cellHeight;
@end
NS_ASSUME_NONNULL_END
