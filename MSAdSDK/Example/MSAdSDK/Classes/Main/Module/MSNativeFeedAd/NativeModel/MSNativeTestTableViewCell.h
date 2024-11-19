//
//  MSNativeTestTableViewCell.h
//  MSAdSDKDev
//
//  Created by leej on 2021/5/8.
//  Copyright © 2021 Adxdata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSNativeTestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSNativeTestTableViewCell : UITableViewCell
@property(nonatomic,strong)MSNativeTestModel *model;
@end

NS_ASSUME_NONNULL_END
