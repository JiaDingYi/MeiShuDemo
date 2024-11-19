//
//  MediaSDKManager.h
//  MSAdSDKDev
//
//  Created by leej on 2022/5/16.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MediaSDKManager : NSObject
+(MediaSDKManager *)shareSdkManager;
//三方sdk是否注册过
-(BOOL)registThirdSdkAppid:(NSString *)appid;
@end

NS_ASSUME_NONNULL_END
