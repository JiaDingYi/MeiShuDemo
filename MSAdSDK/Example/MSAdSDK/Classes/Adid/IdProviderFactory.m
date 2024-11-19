//
//  IdProviderFactory.m
//  Demo
//
//  Created by zzq on 2019/12/31.
//  Copyright © 2019 bwhx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSDefaultSet.h"
#import "IdProviderFactory.h"

MSPlatformName const MSPlatformNameMS     = @"meishu";
MSPlatformName const MSPlatformNameBU     = @"csj";
MSPlatformName const MSPlatformNameGDT    = @"gdt";
MSPlatformName const MSPlatformNameBD     = @"bd";
MSPlatformName const MSPlatformNameJD     = @"jd";
MSPlatformName const MSPlatformNameKS     = @"ks";
MSPlatformName const MSPlatformNameCP     = @"cp";
MSPlatformName const MSPlatformNameADMOB  = @"admob";

@interface IdProviderFactory ()

@end

@implementation IdProviderFactory

+(IAdIdProvider *) getProvider:(NSString *)platformName {
    return  [[NSClassFromString([MSDefaultSet defaultIdPriders][platformName]) alloc]init];
}

+(NSString *)getPidFor:(MSPlatformName)platformName adType:(MSAdType)adtype{
    return [[self getProvider:platformName]getPidAdType:adtype];
}

+(NSString *)getPidFor:(MSPlatformName)platformName nativeType:(MSNativeAdType)adtype{
    NSString *str = [[self getProvider:platformName]getPidNativeType:adtype];
    return str.length>0 ? str : @"";
}

@end
