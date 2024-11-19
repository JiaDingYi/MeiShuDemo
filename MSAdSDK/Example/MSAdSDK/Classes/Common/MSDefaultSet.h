//
//  MSDefaultSet.h
//  MSAdSDKDev
//
//  Created by Liumaos on 2020/7/17.
//  Copyright © 2020 XiXiHaha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IdProviderFactory.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSDefaultSet : NSObject

+(NSDictionary<MSPlatformName,NSString*>*) defaultIdPriders;
+(NSDictionary*) defaultAdVcs;

@end

NS_ASSUME_NONNULL_END
