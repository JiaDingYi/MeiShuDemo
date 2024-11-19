//
//  MSLogger.h
//  MSAdSDKDev
//
//  Created by lj on 2020/8/26.
//  Copyright © 2020 Adxdata. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSLogger : NSObject
+(void)logString:(NSString *)str platform:(MSPlatform)platform;
+(void)logPlatform:(MSPlatform)platform;
+(void)logTestInfo:(NSString *)infoString;
+(void)logString:(NSString *)infoString;
@end

NS_ASSUME_NONNULL_END
