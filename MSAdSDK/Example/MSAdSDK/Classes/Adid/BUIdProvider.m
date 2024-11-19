//
//  CSJIdProvider.m
//  Demo
//
//  Created by zzq on 2019/12/31.
//  Copyright © 2019 bwhx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BUIdProvider.h"

@interface BUIdProvider ()

@end

@implementation BUIdProvider

/** 竖版激励视频 */
-(NSString *) rewardPortrait {
    return @"73646b0799010991";
}
/** 横版激励视频 */
-(NSString *) rewardLandscape {
    return @"73646b0799010991";
}
/** 信息流视频 */
-(NSString *) feedVideo {
    return @"73646b0102010991";
}
/** 信息流三图一文 */
-(NSString *) feedThreeImgs {
    return @"73646b0104010991";
}
/** 信息流上图下文 */
-(NSString *) feedImageVertical {
    return @"73646b0101010991";
}
/** 信息流左图右文 */
-(NSString *) feedImageHorizon {
    return @"73646b0103010991";
}
/** 信息流左图右文图文摘要 */
-(NSString *) feedImageHorizonDesc {
    return @"73646b0103010991";
}
/** 信息流预渲染 */
-(NSString *) feedPreRender {
    return @"73646b0299010991";
}
/** 纯视频 */
-(NSString *) video {
    return @"73646b0699010991";
}
/** 视频暂停贴片 */
-(NSString *) videoImg {
    return @"73646b0602010991";
}
/** 图片 */
-(NSString *) image {
    return @"100424253";
}
/** 插屏 */
-(NSString *) insertScreen {
    return @"73646b0599010991";
}
/** 开屏 */
-(NSString *) splash {
    return @"73646b0499010991";
}
/** banner */
-(NSString *) banner {
    return @"73646b0399010991";
}
-(NSString *)nativeExpress{
    return @"73646b1099911991";
}
/** 平台名称 */
-(NSString *) platformName {
    return @"穿山甲";
}
-(NSString *)fullScreenVideo{
    return @"73646b0999010991";
}
-(NSString *)draw{
    return @"73646b0899010991";
}
@end
