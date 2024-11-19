//
//  MSPidModel.h
//  MSAdSDKDev
//
//  Created by Liumaos on 2020/7/17.
//  Copyright © 2020 XiXiHaha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IdProviderFactory.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSPidModel : NSObject

@property(nonatomic,assign) MSPlatformName platform;
@property(nonatomic,assign) MSAdType   adType;

@property(nonatomic,readonly) NSString *moduleName;
@property(nonatomic,readonly) NSString *pid;
@property(nonatomic,readonly) NSString *vc;

+(instancetype) modelIn:(MSPlatformName)platform adtype:(MSAdType)adtype;

@end

NS_ASSUME_NONNULL_END
