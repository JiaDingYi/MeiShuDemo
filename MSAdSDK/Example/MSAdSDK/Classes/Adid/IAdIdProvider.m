//
//  IAdIdProvider.m
//  Demo
//
//  Created by zzq on 2020/1/2.
//  Copyright © 2020 bwhx. All rights reserved.
//

#import "IAdIdProvider.h"


@interface IAdIdProvider ()

@end

@implementation IAdIdProvider

/** 竖版激励视频 */
-(NSString *) rewardPortrait {return nil;}
/** 横版激励视频 */
-(NSString *) rewardLandscape {return nil;}
/** 信息流视频 */
-(NSString *) feedVideo {return nil;}
/** 信息流三图一文 */
-(NSString *) feedThreeImgs {return nil;}
/** 信息流上图下文 */
-(NSString *) feedImageVertical {return nil;}
/** 信息流左图右文 */
-(NSString *) feedImageHorizon {return nil;}
/** 信息流左图右文图文摘要 */
-(NSString *) feedImageHorizonDesc {return nil;}
/** 信息流预渲染 */
-(NSString *) feedPreRender {return nil;}
/** 纯视频 */
-(NSString *) video {return nil;}
/** 视频暂停贴片 */
-(NSString *) videoImg {return nil;}
/** 图片 */
-(NSString *) image {return nil;}
/** 插屏 */
-(NSString *) insertScreen {return nil;}
/** 开屏 */
-(NSString *) splash {return nil;}
/** banner */
-(NSString *) banner {return nil;}
-(NSString *)nativeExpress{return  nil;}
/** 平台名称 */
-(NSString *) platformName {return nil;}
-(NSString *)fullScreenVideo{return nil;}
-(NSString *)draw{return nil;}
-(NSString*)getPidAdType:(MSAdType)adtype{
    switch (adtype) {
        case MSAdTypeSplash:
            return [self splash];
        case MSAdTypeReward:
            return [self rewardPortrait];
        case MSAdTypeBanner:
            return [self banner];
        case MSAdTypeInterstitial:
            return [self insertScreen];
        case  MSAdTypePaster:
            return [self video];
        case MSAdTypeFeedPreRender:
            return [self feedPreRender];
        case MSAdTypeNativeExpressAd:
            return [self nativeExpress];
        case MSAdTypeFullScreenVideo:
            return [self fullScreenVideo];
        case MSAdTypeDraw:
            return [self draw];
        default:
            break;
    }
    return nil;
}
-(NSString*)getPidNativeType:(MSNativeAdType)nativeType{
    switch (nativeType) {
        case MSNativeAdLeftImage:
        case MSNativeAdLeftImageNoButton:
            return [self feedImageHorizon];
        case MSNativeAdBottomImage:
            return [self feedImageVertical];
        case MSNativeAdThreeImage:
            return  [self feedThreeImgs];
        case MSNativeAdVideo:
            return [self feedVideo];
        default:
            return [self feedImageHorizon];
    }
    return nil;
}

@end
