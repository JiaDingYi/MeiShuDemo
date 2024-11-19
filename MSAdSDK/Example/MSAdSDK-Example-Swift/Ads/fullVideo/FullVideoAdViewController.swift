//
//  FullVideoAdViewController.swift
//  MSAdSDK-Example-Swift
//
//  Created by MSAdSDK on 2023/7/19.
//  Copyright © 2023 MSAdSDK. All rights reserved.
//

import UIKit
import MSAdSDK

class FullVideoAdViewController: BaseAdViewController,MSExpressFullScreenVideoAdDelegate,MSExpressFullScreenVideoAdExtensionFunctionDelegate {
    private var fullVideo:MSExpressFullScreenVideoAd!
    private let param:MSExpressFullScreenVideoAdConfigParams = {
        let _param = MSExpressFullScreenVideoAdConfigParams()
        _param.videoMuted = true
        return _param
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        fullVideo = MSExpressFullScreenVideoAd()
        fullVideo.delegate = self
        fullVideo.extDelegate = self
        fullVideo.load(withPid: pid, adConfigParams: param)
    }
//MSExpressFullScreenVideoAdDelegate 在此回调中调用show接口
    func msExpressFullScreenVideoAdReadySuccess(_ video: MSExpressFullScreenVideoAd!) {
        logAdInfo(string: #function)
        fullVideo.show(fromRootViewController: self)
    }
    func msExpressFullScreenVideoAdDidStarted(_ video: MSExpressFullScreenVideoAd!) {
        logAdInfo(string: #function)
    }
    func msExpressFullScreenVideoAdShowSuccess(_ video: MSExpressFullScreenVideoAd!) {
        logAdInfo(string: #function)
    }
    func msExpressFullScreenVideoAdShowFailed(_ video: MSExpressFullScreenVideoAd!, withError error: Error!) {
        logAdInfo(string: #function+error.localizedDescription)
    }
    func msExpressFullScreenVideoAdReadyFailed(_ video: MSExpressFullScreenVideoAd!, withError error: Error!) {
        logAdInfo(string: #function+error.localizedDescription)
    }
    func msExpressFullScreenVideoAdDidPlayFinish(_ video: MSExpressFullScreenVideoAd!, withError error: Error!) {
        logAdInfo(string: #function)
    }
    func msExpressFullScreenVideoAdDidSkip(_ video: MSExpressFullScreenVideoAd!, withPlayingProgress progress: CGFloat) {
        logAdInfo(string: #function)
    }
    func msExpressFullScreenVideoAdDidClick(_ video: MSExpressFullScreenVideoAd!, withPlayingProgress progress: CGFloat) {
        logAdInfo(string: #function)
    }
    func msExpressFullScreenVideoAdDidClose(_ video: MSExpressFullScreenVideoAd!, withPlayingProgress progress: CGFloat) {
        logAdInfo(string: #function)
    }
    func msExpressFullScreenVideoAdLoadFail(_ video: MSExpressFullScreenVideoAd!, error: Error!) {
        logAdInfo(string: #function+error.localizedDescription)
    }
//MSExpressFullScreenVideoAdExtensionFunctionDelegate
    func msExpressFullScreenVideoAdLoadSuccess(_ video: MSExpressFullScreenVideoAd!) {
        logAdInfo(string: #function)
    }
    func msExpressFullScreenVideoAdPlatformError(_ platform: MSPlatform, videoAd video: MSExpressFullScreenVideoAd!, error: Error!) {
        logAdInfo(string: #function+error.localizedDescription)
    }
}
