//
//  MSTools.h
//  MSAdSDKDev
//
//  Created by Liumaos on 2020/9/2.
//  Copyright © 2020 Adxdata. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSTools : NSObject

+ (CGSize)getTextSize:(NSString *)message
             fontSize:(NSInteger)fontSize
         maxChatWidth:(NSInteger)maxChatWidth;
+ (NSString *)convertStrToTime:(NSString *)timeStr;
+ (NSMutableArray *)adSupportProtocol:(NSString *)protocolName;
@end

NS_ASSUME_NONNULL_END
