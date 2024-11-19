//
//  AdmobIdProvider.m
//  MSAdSDK_Example
//
//  Created by leej on 2022/9/19.
//  Copyright © 2022 Liumao. All rights reserved.
//

#import "AdmobIdProvider.h"

@implementation AdmobIdProvider
/** 竖版激励视频 */
-(NSString *) rewardPortrait {
    return @"100425304";
}
/** 横版激励视频 */
-(NSString *) rewardLandscape {
    return @"100425304";
}
/** 信息流视频 */
-(NSString *) feedVideo {
    return @"";
}
/** 信息流三图一文 */
-(NSString *) feedThreeImgs {
    return @"";
}
/** 信息流上图下文 */
-(NSString *) feedImageVertical {
    return @"";
}
/** 信息流左图右文 */
-(NSString *) feedImageHorizon {
    return @"";
}
/** 信息流左图右文图文摘要 */
-(NSString *) feedImageHorizonDesc {
    return @"";
}
/** 信息流预渲染 */
-(NSString *) feedPreRender {
    return @"100425302";
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
    return @"";
}
/** 插屏 */
-(NSString *) insertScreen {
    return @"100425305";
}
/** 开屏 */
-(NSString *) splash {
    return @"100425303";
}
/** banner */
-(NSString *) banner {
    return @"";
}
-(NSString *)nativeExpress{
    return @"100425289";
}
/** 平台名称 */
-(NSString *) platformName {
    return @"AdMob";
}
-(NSString *)fullScreenVideo{
    return @"";
}
-(NSString *)draw{
    return @"";
}
@end
