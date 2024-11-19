//
//  MediaSDKManager.m
//  MSAdSDKDev
//
//  Created by leej on 2022/5/16.
//  Copyright © 2022 Adxdata. All rights reserved.
//

#import "MediaSDKManager.h"

@interface MediaSDKManager ()
@property(nonatomic,strong)NSMutableDictionary *dictM;
@end

@implementation MediaSDKManager

+(MediaSDKManager *)shareSdkManager{
    static MediaSDKManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MediaSDKManager alloc]init];
    });
    return manager;
}
-(BOOL)registThirdSdkAppid:(NSString *)appid{
    if (!appid) {
        return NO;
    }
    if ([self.dictM.allKeys containsObject:appid]) {
        return YES;
    }else{
        [self.dictM setValue:@"1" forKey:appid];
        return NO;
    }
}
-(NSMutableDictionary *)dictM{
    if (!_dictM) {
        _dictM = [[NSMutableDictionary alloc]init];
    }
    return _dictM;
}
@end
