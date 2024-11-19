//
//  InterstiitialAdViewController.swift
//  MSAdSDK-Example-Swift
//
//  Created by MSAdSDK on 2023/7/19.
//  Copyright © 2023 MSAdSDK. All rights reserved.
//

import UIKit
import MSAdSDK

class InterstiitialAdViewController: BaseAdViewController,MSInterstitialDelegate,MSInterstitialExtensionFunctionDelegate {
    private var interstitialAd:MSInterstitialAd!
    private let param:MSInterstitialAdConfigParams = {
        let _param = MSInterstitialAdConfigParams()
        _param.isNeedCloseAdAfterClick = true
        return _param
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        interstitialAd = MSInterstitialAd()
        interstitialAd.delegate = self
        interstitialAd.extDelegate = self
        interstitialAd.load(withPid: pid, adConfigParams: param)
    }
    //MSInterstitialDelegate
    func msInterstitialAdReadySuccess(_ msInterstitialAd: MSInterstitialAd!) {
        logAdInfo(string: #function)
        interstitialAd.show(fromRootViewController: self)
    }
    func msInterstitialShow(_ msInterstitialAd: MSInterstitialAd!) {
        logAdInfo(string: #function)
    }
    func msInterstitialAdShowFail(_ msInterstitialAd: MSInterstitialAd!, error: Error!) {
        logAdInfo(string: #function+error.localizedDescription)
    }
    func msInterstitialClosed(_ msInterstitialAd: MSInterstitialAd!) {
        logAdInfo(string: #function)
    }
    func msInterstitialClicked(_ msInterstitialAd: MSInterstitialAd!) {
        logAdInfo(string: #function)
    }
    func msInterstitialDetailClosed(_ msInterstitialAd: MSInterstitialAd!) {
        logAdInfo(string: #function)
    }
    func msInterstitialError(_ msInterstitialAd: MSInterstitialAd!, error: Error!) {
        logAdInfo(string: #function+error.localizedDescription)
    }
    //MSInterstitialExtensionFunctionDelegate
    func msInterstitialLoaded(_ msInterstitialAd: MSInterstitialAd!) {
        logAdInfo(string: #function)
    }
    func msInterstitialPlatformError(_ platform: MSPlatform, ad msInterstitialAd: MSInterstitialAd!, error: Error!) {
        logAdInfo(string: #function+error.localizedDescription)
    }
}
