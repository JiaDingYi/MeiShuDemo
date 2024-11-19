//
//  DrawAdViewController.swift
//  MSAdSDK-Example-Swift
//
//  Created by MSAdSDK on 2023/7/19.
//  Copyright © 2023 MSAdSDK. All rights reserved.
//

import UIKit
import MSAdSDK

class DrawAdViewController: BaseAdViewController,MSDrawAdDelegate,MSDrawAdExtensionFunctionDelegate {
    private var draw:MSDrawAd!
    private var container:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        container = UIView.init(frame: CGRect.init(x: 20, y: 100, width: view.bounds.width-40, height: view.bounds.height-150))
        view.addSubview(container)
        draw = MSDrawAd()
        draw.delegate = self
        draw.extDelegate = self
        let param = MSDrawAdConfigParams()
        param.adSize = CGSize.init(width: container.bounds.size.width, height: container.bounds.size.height)
        draw.load(withPid: pid, adConfigParams: param)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.navigationController == nil {
            removeDrawAd()
        }
    }
    func removeDrawAd(){
        draw.dismissView()
        draw.stop()
        container.removeFromSuperview()
        container = nil
    }
    //MSDrawAdDelegate
    func msDrawAdLoadSuccess(_ drawAd: MSDrawAd!) {
        logAdInfo(string: #function)
    }
    func msDrawAdVideoCacheSuccess(_ drawAd: MSDrawAd!) {
        logAdInfo(string: #function)
        draw.showView(inContainer: container, presentVC: self)
        draw.setVideoMute(true)
        draw.play()
    }
    func msDrawAdVideoDidClick(_ drawAd: MSDrawAd!) {
        logAdInfo(string: #function)
    }
    func msDrawAdVideoDidPause(_ drawAd: MSDrawAd!) {
        logAdInfo(string: #function)
    }
    func msDrawAdVideoDidClosed(_ drawAd: MSDrawAd!) {
        logAdInfo(string: #function)
        removeDrawAd()
    }
    func msDrawAdVideoDidReplay(_ drawAd: MSDrawAd!) {
        logAdInfo(string: #function)
    }
    func msDrawAdVideoDidComplete(_ drawAd: MSDrawAd!) {
        logAdInfo(string: #function)
    }
    func msDrawAdVideoShowSuccess(_ drawAd: MSDrawAd!) {
        logAdInfo(string: #function)
    }
    func msDrawAdVideoDetailClosed(_ drawAd: MSDrawAd!) {
        logAdInfo(string: #function)
    }
    func msDrawAdVideoDidStartPlaying(_ drawAd: MSDrawAd!) {
        logAdInfo(string: #function)
    }
    func msDrawAdLoadFail(_ drawAd: MSDrawAd!, withError error: Error!) {
        logAdInfo(string: #function+error.localizedDescription)
    }
    func msDrawAdVideoDidFailed(_ drawAd: MSDrawAd!, withError error: Error!) {
        logAdInfo(string: #function+error.localizedDescription)
        removeDrawAd()
    }
    func msDrawAdVideoShowFailed(_ drawAd: MSDrawAd!, withError error: Error!) {
        logAdInfo(string: #function+error.localizedDescription)
        removeDrawAd()
    }
    func msDrawAdVideoCacheFailed(_ drawAd: MSDrawAd!, withError error: Error!) {
        logAdInfo(string: #function+error.localizedDescription)
    }
    //MSDrawAdExtensionFunctionDelegate
    func msDrawAdPlatformError(_ platform: MSPlatform, videoAd drawAd: MSDrawAd!, error: Error!) {
        logAdInfo(string: #function+error.localizedDescription)
    }
}
