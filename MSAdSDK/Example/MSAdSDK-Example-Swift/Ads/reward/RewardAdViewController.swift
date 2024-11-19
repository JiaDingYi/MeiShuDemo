//
//  RewardAdViewController.swift
//  MSAdSDK-Example-Swift
//
//  Created by MSAdSDK on 2023/7/19.
//  Copyright © 2023 MSAdSDK. All rights reserved.
//

import UIKit
import MSAdSDK

class RewardAdViewController: BaseAdViewController,MSRewardVideoAdDelegate,MSRewardVideoAdExtensionFunctionDelegate {
    private var reward:MSRewardVideoAd!
    private let param:MSRewardAdConfigParams = {
        let _param = MSRewardAdConfigParams()
        _param.videoMuted = true
        _param.userId = "123";//此处媒体需传入真实的userid
        return _param
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        reward = MSRewardVideoAd()
        reward.delegate = self
        reward.extDelegate = self
        reward.load(withPid: pid, adConfigParams: param)
    }
    //MSRewardVideoAdDelegate
    func msRewardVideoLoaded(_ msRewardVideoAd: MSRewardVideoAd!) {
        logAdInfo(string: #function)
    }
    //在此回调调用show接口
    func msRewardVideoCached(_ msRewardVideoAd: MSRewardVideoAd!) {
        logAdInfo(string: #function)
        reward.show(fromRootViewController: self)
    }
    func msRewardVideoRenderSuccess(_ msRewardVideoAd: MSRewardVideoAd!) {
        logAdInfo(string: #function)
    }
    func msRewardVideoRenderFail(_ msRewardVideoAd: MSRewardVideoAd!, error: Error!) {
        logAdInfo(string: #function+error.localizedDescription)
    }
    func msRewardVideoWillShow(_ msRewardVideoAd: MSRewardVideoAd!) {
        logAdInfo(string: #function)
    }
    func msRewardVideoShow(_ msRewardVideoAd: MSRewardVideoAd!) {
        logAdInfo(string: #function)
    }
    func msRewardVideoStartPlaying(_ msRewardVideoAd: MSRewardVideoAd!) {
        logAdInfo(string: #function)
    }
    func msRewardVideoStopPlaying(_ msRewardVideoAd: MSRewardVideoAd!) {
        logAdInfo(string: #function)
    }
    func msRewardVideoResumePlaying(_ msRewardVideoAd: MSRewardVideoAd!) {
        logAdInfo(string: #function)
    }
    func msRewardVideoClicked(_ msRewardVideoAd: MSRewardVideoAd!) {
        logAdInfo(string: #function)
    }
    func msRewardVideoClosed(_ msRewardVideoAd: MSRewardVideoAd!) {
        logAdInfo(string: #function)
    }
    func msRewardVideoFinish(_ msRewardVideoAd: MSRewardVideoAd!) {
        logAdInfo(string: #function)
    }
    func msRewardVideoError(_ msRewardVideoAd: MSRewardVideoAd!, error: Error!) {
        logAdInfo(string: #function+error.localizedDescription)
    }
    /**
     视频广告播放达到激励条件回调
     @param msRewardVideoAd MSRewardVideoAd 实例
     @param adInfo 激励信息包含的内容格式示例如下：
     {
      @"GDTRewardInfo" : 字典，//广点通返回的信息,注意此字段只有广点通平台激励视频才会返回，媒体获取时务必检查是否为空
      @"rewardVerify"  : @"1",//是否达到发放奖励条件，此值为必传项，取值范围【0-1】，0:未达到，1:达到
      @"rewardName"    : @"各种豆",//奖励名称，该值可能为空，可在ms平台进行配置
      @"rewardAmount"  : @"10",//奖励数量，该值可能为空，可在ms平台进行配置
      @"rewardVerifyError" : @"未知错误",//服务端验证错误信息，该值可能为空
     }
     详解：是否支持服务端验证都会触发激励回调，其他详解请查看接入文档
     */
    func msRewardVideoReward(_ msRewardVideoAd: MSRewardVideoAd!, extInfo adInfo: [AnyHashable : Any]!) {
        let rewardVerify:String = adInfo["rewardVerify"] as! String
        if rewardVerify == "1" {
            logAdInfo(string: "奖励发放成功")
        } else {
            logAdInfo(string: "激励发放失败")
        }
    }
    func msRewardVideoPlayingError(_ msRewardVideoAd: MSRewardVideoAd!, error: Error!) {
        logAdInfo(string: "msRewardVideoPlayingError"+error.localizedDescription)
    }
    func msRewardVideoClickSkip(_ msRewardVideoAd: MSRewardVideoAd!, currentTime: TimeInterval) {
        logAdInfo(string: "msRewardVideoClickSkip")
    }
    //MSRewardVideoAdExtensionFunctionDelegate
    func msRewardVideoPlatformError(_ msRewardVideoAd: MSRewardVideoAd!, platform: MSPlatform, error: Error!) {
        logAdInfo(string: "msRewardVideoPlatformError"+error.localizedDescription)
    }
}
