//
//  NativeExpressAdViewController.swift
//  MSAdSDK-Example-Swift
//
//  Created by MSAdSDK on 2023/7/19.
//  Copyright © 2023 MSAdSDK. All rights reserved.
//

import UIKit
import MSAdSDK

class NativeExpressAdViewController: BaseAdViewController,MSNativeFeedAdDelegate,MSNativeFeedAdExtensionFunctionDelegate,MSNativeSimpleCustomAdViewDelegate,MSNativeSimpleCustomVideoAdViewDelegate {
    private var nativeExpress:MSNativeFeedAd!
    private var container:UIView!
    private var adView:UIView?
    private let param:MSNativeFeedAdConfigParams = {
        let _param = MSNativeFeedAdConfigParams()
        _param.videoMuted = true
        _param.adCount = 1
        _param.prerenderAdSize = CGSize.init(width: UIScreen.main.bounds.size.width-40, height: 0)
        return _param
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        container = UIView.init(frame: CGRect.init(x: 20, y: 100, width: view.bounds.size.width-40, height: 400))
        view.addSubview(container)
        container.backgroundColor = .lightGray
        nativeExpress = MSNativeFeedAd()
        nativeExpress.delegate = self
        nativeExpress.extDelegate = self
        nativeExpress.load(withPid: pid, adParam: param)
    }
    //页面销毁时清空广告
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.navigationController == nil && adView != nil{
            if adView!.isKind(of: MSNativeSimpleCustomAdView.self){
                let tempAdView:MSNativeSimpleCustomAdView = adView as! MSNativeSimpleCustomAdView
                tempAdView.destoryNativeCustomAdView()
            } else if adView!.isKind(of: MSNativeSimpleCustomVideoAdView.self){
                let tempAdView:MSNativeSimpleCustomVideoAdView = adView as! MSNativeSimpleCustomVideoAdView
                tempAdView.destoryNativeCustomVideoAdView()
            } else {
                adView!.removeFromSuperview()
                adView = nil
            }
        }
    }
    /**
     MSNativeFeedAdDelegate
     成功回调中demo示例只处理了一条广告，媒体接入时按照实际获取到广告条数展示即可
     */
    func msNativeFeedAdLoaded(_ nativeFeedAd: MSNativeFeedAd, feedAds: [MSNativeFeedAdModel]) {
        logAdInfo(string: #function)
        if feedAds.count > 0 {
            let model:MSNativeFeedAdModel = feedAds[0]
            //必须指定vc
            model.presentVC = self
            //判断是的是信息流模版广告
            if model.isNativeExpress {
                adView = model.feedView
                container.addSubview(model.feedView!)
            } else {
                //非视频类型自渲染广告
                if model.adMaterialMeta?.metaCreativeType() != MSCreativeType.video {
                    let view:MSNativeSimpleCustomAdView = MSNativeSimpleCustomAdView()
                    adView = view
                    view.delegate = self
                    view.presentVc = self
                    view.loadFeedAdMeta(feedAdMeta: model.adMaterialMeta!)
                    view.showNativeAd(withClick: view.customImageAdViewClickViews(), presentVC: self)
                    view.openInteraction()
                    container.addSubview(view)
                    container.frame = CGRect.init(x: container.frame.origin.x, y: container.frame.origin.y, width: container.bounds.width, height: view.calculateAdHeightWithFeedAdMeta(feedAd: model.adMaterialMeta!))
                } else {
                    let view:MSNativeSimpleCustomVideoAdView = MSNativeSimpleCustomVideoAdView()
                    adView = view
                    view.delegate = self
                    view.presentVc = self
                    view.loadFeedAdMeta(feedAdMeta: model.adMaterialMeta!)
                    view.showNativeAd(withClick: view.customVideoAdViewClickViews(), presentVC: self)
                    view.openInteraction()
                    container.addSubview(view)
                    container.frame = CGRect.init(x: container.frame.origin.x, y: container.frame.origin.y, width: container.bounds.width, height: view.calculateAdHeightWithFeedAdMeta(feedAd: model.adMaterialMeta!))
                }
            }
        } else {
            msNativeFeedAdError(nativeFeedAd, withError: NSError())
        }
    }
    func msNativeFeedAdError(_ nativeFeedAd: MSNativeFeedAd, withError error: Error) {
        logAdInfo(string: #function+error.localizedDescription)
    }
    func msNativeFeedAdMaterialMetaReadySuccess(_ nativeFeedAd: MSNativeFeedAd, feedAd: MSNativeFeedAdModel) {
        logAdInfo(string: #function)
        if feedAd.isNativeExpress {
            container.frame = CGRect.init(x: container.frame.origin.x, y: container.frame.origin.y, width: feedAd.feedView!.bounds.size.width, height: feedAd.feedView!.bounds.size.height)
        }
    }
    func msNativeFeedAdMaterialMetaReadyError(_ nativeFeedAd: MSNativeFeedAd, feedAd: MSNativeFeedAdModel, error: Error) {
        logAdInfo(string: #function+error.localizedDescription)
    }
    func msNativeFeedAdShow(_ feedAd: MSNativeFeedAdModel) {
        logAdInfo(string: #function)
    }
    func msNativeFeedAdShowFailed(_ feedAd: MSNativeFeedAdModel, error: Error) {
        logAdInfo(string: #function+error.localizedDescription)
    }
    func msNativeFeedAdClick(_ feedAd: MSNativeFeedAdModel) {
        logAdInfo(string: #function)
    }
    func msNativeFeedAdClosed(_ feedAd: MSNativeFeedAdModel) {
        logAdInfo(string: #function)
        container.removeFromSuperview()
    }
    func msNativeFeedAdDetailShow() {
        logAdInfo(string: #function)
    }
    func msNativeFeedAdDetailClosed() {
        logAdInfo(string: #function)
    }
    func msNativeFeedAdVideoStateDidChanged(_ playerState: MSPlayerPlayState, feedAd: MSNativeFeedAdModel) {
        var statusStr:String? = nil
        switch playerState {
            case .stateStarted:
                statusStr = "开始播放"
            case .stateFailed:
                statusStr = "播放失败"
            case .statePlaying:
                statusStr = "播放中"
            case .statePause:
                statusStr = "暂停播放"
            case .stateStopped:
                statusStr = "播放完成"
            default:
                statusStr = "未知状态"
        }
        logAdInfo(string: #function+statusStr!)
    }
    func nativeSimpleImageAdViewClosed(adView: MSNativeCustomAdView) {
        logAdInfo(string: #function)
        container.removeFromSuperview()
    }
    func nativeSimpleVideoAdViewClosed(adView: MSNativeCustomVideoAdView) {
        logAdInfo(string: #function)
        container.removeFromSuperview()
    }
    //MSNativeFeedAdExtensionFunctionDelegate
    func msNativeFeedAdPlatformError(_ platform: MSPlatform, nativeFeedAd: MSNativeFeedAd, error: Error) {
        logAdInfo(string: #function+error.localizedDescription)
    }
}
