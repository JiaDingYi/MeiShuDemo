//
//  MSNativeSimpleCustomVideoAdView.swift
//  MSAdSDK-Example-Swift
//
//  Created by MSAdSDK on 2023/7/20.
//  Copyright © 2023 MSAdSDK. All rights reserved.
//

import UIKit
import MSAdSDK
import SnapKit
public protocol MSNativeSimpleCustomVideoAdViewDelegate:NSObjectProtocol {
    func nativeSimpleVideoAdViewClosed(adView:MSNativeCustomVideoAdView)
}
class MSNativeSimpleCustomVideoAdView: MSNativeCustomVideoAdView {
//    private var shakeTwist:MSNativeAdShakeTwist?
    private var clickViews:Array<UIView> = Array.init()
    weak var presentVc:UIViewController?
    weak var delegate:MSNativeSimpleCustomVideoAdViewDelegate?
    func loadFeedAdMeta(feedAdMeta:MSFeedAdMeta){
        //第一步 设置广告容器frame
        self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width-40, height: calculateAdHeightWithFeedAdMeta(feedAd: feedAdMeta))
        //第二步 创建广告元素子控件并添加内容
        let closeBtn:UIButton = createCloseBtn()
        
        let iconImageView:UIImageView = createImgView()
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.cornerRadius = 10
        
        let actionLabel:UILabel = createLabel()
        actionLabel.textColor = .orange
        actionLabel.layer.masksToBounds = true
        actionLabel.layer.cornerRadius = 5
        actionLabel.layer.borderColor = UIColor.orange.cgColor
        actionLabel.layer.borderWidth = 1
        actionLabel.textAlignment = .center
        actionLabel.font = UIFont.systemFont(ofSize: 13)
        
        let titleLabel:UILabel = createLabel()
        titleLabel.text = feedAdMeta.metaTitle()
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.numberOfLines = 2
        
        let sourceLabel:UILabel = createLabel()
        sourceLabel.text = feedAdMeta.metaSource()
        sourceLabel.font = UIFont.systemFont(ofSize: 13)
        sourceLabel.textColor = .orange
        
        let contentLabel:UILabel = createLabel()
        contentLabel.text = feedAdMeta.metaContent()
        contentLabel.font = UIFont.systemFont(ofSize: 13)
        contentLabel.numberOfLines = 2
        
        let config:MSFeedVideoConfig = MSFeedVideoConfig()
        config.isMute = true
        config.isAutoPlay = true
        //第三步 将广告元素子控件传入 内部会把传入的子控件添加到容器中 媒体无需再次添加
        load(withFrame: self.bounds, feedAdMeta: feedAdMeta, metaLogo: feedAdMeta.metaLogo(), closeBtn: closeBtn, videoConfig: config, iconImageView: iconImageView, actionLabel: actionLabel, titleLabel: titleLabel, sourceLabel: sourceLabel, contentLabel: contentLabel)
        //第四步 布局广告元素子控件
        layoutNativeCustomVideoAdViewSubViews()
        //第五步 【非必需】 如媒体想支持新交互方式可在下面注册交互即可
//        if MSNativeAdShakeTwist.canSupport(feedAdMeta){
//            shakeTwist = MSNativeAdShakeTwist()
//            shakeTwist?.presentVC = presentVc
//            shakeTwist?.registShakeTwist(feedAdMeta)
//            self.addSubview(shakeTwist!.interActionbrandLogo)
//        }
    }
    //布局子控件
    func layoutNativeCustomVideoAdViewSubViews() {
        closeBtn.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.right.equalTo(self)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        if feedAdData.metaIcon() != nil {
            iconImageView?.snp.makeConstraints({ make in
                make.top.equalTo(self).offset(10)
                make.left.equalTo(self).offset(20)
                make.size.equalTo(CGSize.init(width: 60, height: 60))
            })
            clickViews.append(iconImageView!)
            loadImage(adImage: iconImageView!, url: feedAdData.metaIcon()!)
        } else {
            iconImageView?.isHidden = true
        }
        if feedAdData.metaTitle() != nil {
            metaTitleLabel.snp.makeConstraints { make in
                make.top.equalTo(self).offset(10)
                make.right.lessThanOrEqualTo(closeBtn.snp.left).offset(-10)
                make.left.equalTo(feedAdData.metaIcon() != nil ? iconImageView!.snp.right : self).offset(20)
            }
            clickViews.append(metaTitleLabel)
        } else {
            metaTitleLabel.isHidden = true
        }
        if feedAdData.metaContent() != nil {
            metaContentLabel.snp.makeConstraints { make in
                make.right.lessThanOrEqualTo(closeBtn.snp.left).offset(-10)
                make.left.equalTo(feedAdData.metaIcon() != nil ? iconImageView!.snp.right : self).offset(20)
                make.top.equalTo(feedAdData.metaTitle() != nil ? metaTitleLabel.snp.bottom : self).offset(10)
            }
            clickViews.append(metaContentLabel)
        } else {
            metaContentLabel.isHidden = true
        }
        videoView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            if feedAdData.metaIcon() != nil {
                make.top.equalTo(iconImageView!.snp.bottom).offset(10)
            } else if feedAdData.metaContent() != nil {
                make.top.equalTo(metaContentLabel.snp.bottom).offset(10)
            } else if feedAdData.metaTitle() != nil {
                make.top.equalTo(metaTitleLabel.snp.bottom).offset(10)
            } else {
                make.top.equalTo(self).offset(10)
            }
            make.bottom.equalTo(self).offset(-40)
        }
        clickViews.append(videoView)
        if feedAdData.metaSource() != nil {
            metaSourceLabel?.snp.makeConstraints({ make in
                make.width.lessThanOrEqualTo(100)
                make.left.equalTo(self).offset(20)
                make.top.equalTo(videoView.snp.bottom).offset(10)
            })
            clickViews.append(metaSourceLabel!)
        } else {
            metaSourceLabel?.isHidden = true
        }
        
        if feedAdData.metaActionTitle() != nil {
            metaActionLabel?.snp.makeConstraints({ make in
                make.right.lessThanOrEqualTo(self).offset(-20)
                make.top.equalTo(videoView.snp.bottom).offset(10)
                make.left.equalTo(feedAdData.metaSource() != nil ? metaSourceLabel!.snp.right : self).offset(20)
            })
            clickViews.append(metaActionLabel!)
        } else {
            metaActionLabel?.isHidden = true
        }
        videoView.layoutIfNeeded()
        /**
         设置logo位置
         1、为兼容三方广告logo 一致通过setMetaLogoFrame设置
         2、logo是添加videoView上的 设置LogoFrame时，以videoView为参考
         */
        feedAdData.setMetaLogoFrame(CGRect.init(x: videoView.bounds.size.width - 40, y: videoView.bounds.size.height-15, width: 40, height: 15))
    }
    //获取可点击子控件
    func customVideoAdViewClickViews() -> Array<UIView> {
        return clickViews
    }
    //展示时开启交互
    func openInteraction() {
//        if MSNativeAdShakeTwist.canSupport(feedAdData){
//            shakeTwist?.start()
//        }
    }
    //不再展示时关闭交互
    func closeInteraction() {
//        if MSNativeAdShakeTwist.canSupport(feedAdData){
//            shakeTwist?.stop()
//        }
    }
    //销毁交互组件
    func destoryInteraction(){
//        if MSNativeAdShakeTwist.canSupport(feedAdData){
//            shakeTwist?.destoryShakeTwist()
//        }
    }
    @objc func closeAd(){
//        if shakeTwist != nil {
//            destoryInteraction()
//        }
        destoryNativeCustomVideoAdView()
        clickViews.removeAll()
        if delegate != nil {
            delegate?.nativeSimpleVideoAdViewClosed(adView: self)
        }
    }
    func createLabel() -> UILabel {
        let label = UILabel()
        return label
    }
    func createImgView() -> UIImageView {
        let img = UIImageView()
        return img
    }
    func createCloseBtn() -> UIButton {
        let button = UIButton.init(type: .custom)
        button.setTitle("X", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(closeAd), for: .touchUpInside)
        return button
    }
    func loadImage(adImage:UIImageView , url:String) {
        if url.isEmpty {
            return
        }
        DispatchQueue.global(qos: .background).async {
            let imgUrl:NSURL = NSURL(string: url)!
            let imgData = NSData.init(contentsOf: imgUrl as URL)
            DispatchQueue.main.async {
                adImage.image = UIImage(data: imgData! as Data)
            }
        }
    }
    func calculateAdHeightWithFeedAdMeta(feedAd:MSFeedAdMeta) -> CGFloat{
        return CGFloat(350)
    }
}
