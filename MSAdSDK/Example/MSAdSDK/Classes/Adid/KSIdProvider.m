//
//  KSIdProvider.m
//  MSAdSDKDev
//
//  Created by lj on 2021/4/29.
//  Copyright © 2021 Adxdata. All rights reserved.
//

#import "KSIdProvider.h"

@implementation KSIdProvider
/** 竖版激励视频 */
-(NSString *) rewardPortrait {
    return @"73646b0703050991";
}
/** 横版激励视频 */
-(NSString *) rewardLandscape {
    return @"73646b0799020991";
}
/** 信息流视频 */
-(NSString *) feedVideo {
    return @"73646b0104050991";
}
/** 信息流三图一文 */
-(NSString *) feedThreeImgs {
    return @"73646b0104050991";
}
/** 信息流上图下文 */
-(NSString *) feedImageVertical {
    return @"73646b0101050991";
}
/** 信息流左图右文 */
-(NSString *) feedImageHorizon {
    return @"73646b0103050991";
}
/** 信息流左图右文图文摘要 */
-(NSString *) feedImageHorizonDesc {
    return @"73646b0103050991";
}
/** 信息流预渲染 */
-(NSString *) feedPreRender {
    return @"73646b0203050991";
}
/** 纯视频 */
-(NSString *) video {
    return @"";
}
/** 视频暂停贴片 */
-(NSString *) videoImg {
    return @"";
}
/** 图片 */
-(NSString *) image {
    return @"100424253";
}
/** 插屏 */
-(NSString *) insertScreen {
    return @"73646b0599050991";
}
/** 开屏 */
-(NSString *) splash {
    return @"73646b0499050991";
}
/** banner */
-(NSString *) banner {
    return @"";
}
-(NSString *)nativeExpress{
    return @"73646b1099910991";
}
-(NSString *)fullScreenVideo{
    return @"73646b0999050991";
}
-(NSString *)draw{
    return @"73646b0899050991";
}
/** 平台名称 */
-(NSString *) platformName {
    return @"快手";
}
@end
