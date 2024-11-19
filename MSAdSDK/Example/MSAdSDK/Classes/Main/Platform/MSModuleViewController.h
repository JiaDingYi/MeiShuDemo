//
//  MSBaseViewController.h
//  MSAdSDKDev
//
//  Created by Liumaos on 2020/7/17.
//  Copyright © 2020 XiXiHaha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSPidModel.h"
#import "IdProviderFactory.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSModuleViewController : UIViewController

-(void)loadData:(NSMutableArray<MSPidModel*> *)dataArray;

@property(nonatomic,copy)   MSPlatformName platformName;

@end

NS_ASSUME_NONNULL_END
