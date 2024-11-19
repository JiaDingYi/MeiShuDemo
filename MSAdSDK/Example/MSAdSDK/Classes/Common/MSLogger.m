//
//  MSLogger.m
//  MSAdSDKDev
//
//  Created by lj on 2020/8/26.
//  Copyright © 2020 Adxdata. All rights reserved.
//

#import "MSLogger.h"
#define MSLogFormat(string,platformName) [NSString stringWithFormat:@"[FUNC]%s---%@ %@",__func__,string,platformName]

@implementation MSLogger

+(void)logString:(NSString *)str platform:(MSPlatform)platform{
    
#if DEBUG
    NSLog(@"%@",MSLogFormat(str,[self matchPlatformName:platform]));
#endif
}
+(void)logPlatform:(MSPlatform)platform{
#if DEBUG
    NSLog(@"%@",[self matchPlatformName:platform]);
#endif
}
+(void)logTestInfo:(NSString *)infoString{
#if DEBUG
    NSLog(@"%@",infoString);
#endif
}
+(void)logString:(NSString *)str{
#if DEBUG
    NSLog(@"[MSSDKDemo 日志]%@",str);
#endif
}
+ (NSString *)matchPlatformName:(MSPlatform)platform{
    switch (platform) {
        case MSPlatformBD:
            return [NSString stringWithFormat:@"当前平台:百度 === 平台标识：%d",(int)platform];
        case MSPlatformBU:
            return [NSString stringWithFormat:@"当前平台:穿山甲 === 平台标识：%d",(int)platform];
        case MSPlatformMS:
            return [NSString stringWithFormat:@"当前平台:ms === 平台标识：%d",(int)platform];
        case MSPlatformGDT:
            return [NSString stringWithFormat:@"当前平台:广点通 === 平台标识：%d",(int)platform];
        case MSPlatformJD:
            return [NSString stringWithFormat:@"当前平台:京东 === 平台标识：%d",(int)platform];
        case MSPlatformKS:
            return [NSString stringWithFormat:@"当前平台:快手 === 平台标识：%d",(int)platform];
        default:
            return [NSString stringWithFormat:@"当前平台:未知 === 平台标识：%d",(int)platform];
    }
}
@end
