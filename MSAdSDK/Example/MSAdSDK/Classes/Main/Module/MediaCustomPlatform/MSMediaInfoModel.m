//
//  MSMediaInfoModel.m
//  MSAdSDKDev
//
//  Created by leej on 2022/9/18.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MSMediaInfoModel.h"

@implementation MSMediaInfoModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}
-(void)setNilValueForKey:(NSString *)key{}
@end
