//
//  BannerAdViewController.swift
//  MSAdSDK-Example-Swift
//
//  Created by MSAdSDK on 2023/7/19.
//  Copyright © 2023 MSAdSDK. All rights reserved.
//

import UIKit
import MSAdSDK

class BannerAdViewController: BaseAdViewController,MSBannerViewDelegate,MSBannerViewExtensionFunctionDelegate {
    private var banner:MSBannerView!
    private var container:UIView!
    private let param:MSBannerAdConfigParams = {
        let _param = MSBannerAdConfigParams()
        _param.showCloseBtn = true
        return _param
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        container = UIView.init(frame: CGRect.init(x: 20, y: 100, width: view.bounds.width-40, height: 80))
        view.addSubview(container)
        banner = MSBannerView.init(frame: container.bounds)
        banner.delegate = self
        banner.extDelegate = self
        banner.loadAdAndShow(withPid: pid, presentVC: self, adParams: param)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if navigationController == nil {
            banner.dismiss()
            banner = nil
        }
    }
    //MSBannerViewDelegate
    func msBannerAdReadySuccess(_ msBannerAd: MSBannerView!) {
        logAdInfo(string: #function)
        container.addSubview(banner)
    }
    func msBannerAdRenderSuccess(_ msBannerAd: MSBannerView!) {
        logAdInfo(string: #function)
    }
    func msBannerAdRenderFail(_ msBannerAd: MSBannerView!, error: Error!) {
        logAdInfo(string: #function+error.localizedDescription)
    }
    func msBannerShow(_ msBannerAd: MSBannerView!) {
        logAdInfo(string: #function)
    }
    func msBannerClicked(_ msBannerAd: MSBannerView!) {
        logAdInfo(string: #function)
    }
    func msBannerClosed(_ msBannerAd: MSBannerView!) {
        logAdInfo(string: #function)
        banner.dismiss()
    }
    func msBannerDetailShow(_ msBannerAd: MSBannerView!) {
        logAdInfo(string: #function)
    }
    func msBannerDetailClosed(_ msBannerAd: MSBannerView!) {
        logAdInfo(string: #function)
    }
    func msBannerError(_ msBannerAd: MSBannerView!, error: Error!) {
        logAdInfo(string: #function+error.localizedDescription)
    }
    //MSBannerViewExtensionFunctionDelegate
    func msBannerLoaded(_ msBannerAd: MSBannerView!) {
        logAdInfo(string: #function)
    }
    func msBannerPlatformError(_ platform: MSPlatform, bannerAd msBannerAd: MSBannerView!, error: Error!) {
        logAdInfo(string: #function+error.localizedDescription)
    }
}
