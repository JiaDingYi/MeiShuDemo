//
//  SplashAdViewController.swift
//  MSAdSDK-Example-Swift
//
//  Created by MSAdSDK on 2023/7/19.
//  Copyright © 2023 MSAdSDK. All rights reserved.
//

import UIKit
import MSAdSDK

class SplashAdViewController: BaseAdViewController,MSSplashAdDelegate,MSSplashAdExtensionFuctionDelegate {
    private var splash:MSSplashAd!
    private let param:MSSplashAdConfigParams = {
        let _param = MSSplashAdConfigParams()
        _param.fetchDelay = 5
        _param.adSize = UIScreen.main.bounds.size
        return _param
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        splash = MSSplashAd()
        splash.delegate = self
        splash.extDelegate = self
        splash.load(withPid: pid, adParam: param)
    }
    //广告生命周期回调
    func msSplashAdReadySuccess(_ splashAd: MSSplashAd!) {
        logAdInfo(string: #function)
        let window = UIApplication.shared.keyWindow!
        splash.show(in: window)
    }
    func msSplashShow(_ splashAd: MSSplashAd!) {
        logAdInfo(string: #function)
    }
    func msSplashPresent(_ splashAd: MSSplashAd!) {
        logAdInfo(string: #function)
    }
    func msSplashClicked(_ splashAd: MSSplashAd!) {
        logAdInfo(string: #function)
    }
    func msSplashSkip(_ splashAd: MSSplashAd!) {
        logAdInfo(string: #function)
    }
    func msSplashWillClosed(_ splashAd: MSSplashAd!) {
        logAdInfo(string: #function)
    }
    func msSplashClosed(_ splashAd: MSSplashAd!) {
        logAdInfo(string: #function)
    }
    func msSplashDetailClosed(_ splashAd: MSSplashAd!) {
        logAdInfo(string: #function)
    }
    func msSplashError(_ splashAd: MSSplashAd!, withError error: Error!) {
        logAdInfo(string: #function+error.localizedDescription)
    }
    func msSplashAdShowFail(_ splashAd: MSSplashAd!, error: Error!) {
        logAdInfo(string: #function+error.localizedDescription)
    }
    /**
     开屏广告其他扩展功能回调（包含统计、获取个性化参数等回调）
     */
    func msSplashStartLoaded(_ splashAd: MSSplashAd!, currentLoad loadPlatform: MSPlatform) {
        logAdInfo(string: #function)
    }
    func msSplashLoaded(_ splashAd: MSSplashAd!) {
        logAdInfo(string: #function)
    }
    func msSplashPlatformError(_ platform: MSPlatform, splashAd: MSSplashAd!, error: Error!) {
        logAdInfo(string: #function+error.localizedDescription)
    }
    
}
