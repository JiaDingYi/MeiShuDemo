//
//  MSNativeSimpleCustomAdView.swift
//  MSAdSDK-Example-Swift
//
//  Created by MSAdSDK on 2023/7/20.
//  Copyright © 2023 MSAdSDK. All rights reserved.
//

import UIKit
import MSAdSDK
import SnapKit
public protocol MSNativeSimpleCustomAdViewDelegate:NSObjectProtocol {
    func nativeSimpleImageAdViewClosed(adView:MSNativeCustomAdView)
}
class MSNativeSimpleCustomAdView: MSNativeCustomAdView {
//    private var shakeTwist:MSNativeAdShakeTwist?
    private var clickViews:Array<UIView> = Array.init()
    weak var presentVc:UIViewController?
    weak var delegate:MSNativeSimpleCustomAdViewDelegate?
    func loadFeedAdMeta(feedAdMeta:MSFeedAdMeta){
        var imgArr:Array<UIImageView> = Array.init()
        //第一步 设置广告容器frame
        self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width-40, height: calculateAdHeightWithFeedAdMeta(feedAd: feedAdMeta))
        //第二步 创建广告元素子控件并添加内容
        let closeBtn:UIButton = createCloseBtn()
        if feedAdMeta.metaCreativeType() == .image ||
           feedAdMeta.metaCreativeType() == .largeImage {
            let img = createImgView()
            let imgUrl = feedAdMeta.metaImageUrls()?[0]
            loadImage(adImage: img, url: imgUrl ?? "")
            imgArr.append(img)
        } else if feedAdMeta.metaCreativeType() == .smallImage {
            let img = createImgView()
            let imgUrl = feedAdMeta.metaImageUrls()?[0]
            loadImage(adImage: img, url: imgUrl ?? "")
            imgArr.append(img)
        } else if feedAdMeta.metaCreativeType() == .threeImage {
            let arr:[String] = feedAdMeta.metaImageUrls()!
            for imgUrl in arr{
                let img = self.createImgView()
                self.loadImage(adImage: img, url:imgUrl)
                imgArr.append(img)
            }
        }
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
        
        //第三步 将广告元素子控件传入 内部会把传入的子控件添加到容器中 媒体无需再次添加
        loadNativeCustomAd(with: feedAdMeta, metaLogo: feedAdMeta.metaLogo(), closeBtn: closeBtn, imgViews: imgArr, iconImageView: iconImageView, actionLabel: actionLabel, titleLabel: titleLabel, sourceLabel: sourceLabel, contentLabel: contentLabel)
        //第四步 布局广告元素子控件
        layoutNativeCustomImageAdViewSubViews()
        //第五步 【非必需】 如媒体想支持新交互方式可在下面注册交互即可
//        if MSNativeAdShakeTwist.canSupport(feedAdMeta) {
//            shakeTwist = MSNativeAdShakeTwist()
//            shakeTwist?.presentVC = presentVc
//            shakeTwist?.registShakeTwist(feedAdMeta)
//            self.addSubview(shakeTwist!.interActionbrandLogo)
//        }
    }
    //布局子控件
    func layoutNativeCustomImageAdViewSubViews() {
        //设置logo位置(默认广告容器右下角) 为兼容三方广告logo 一致通过setMetaLogoFrame设置
        feedAdData.setMetaLogoFrame(CGRect.init(x: self.bounds.size.width - 60, y: self.bounds.size.height-20, width: 40, height: 15))
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
                if (feedAdData.metaContent() != nil) {
                    make.top.equalTo(self).offset(10)
                } else if feedAdData.metaIcon() != nil {
                    make.centerY.equalTo(iconImageView!)
                } else {
                    make.top.equalTo(self).offset(10)
                }
                make.right.lessThanOrEqualTo(closeBtn.snp.left).offset(-10)
                make.left.equalTo(feedAdData.metaIcon() != nil ? iconImageView!.snp.right : self).offset(20)
            }
            clickViews.append(metaTitleLabel)
        } else {
            metaTitleLabel.isHidden = true
        }
        if feedAdData.metaContent() != nil {
            metaContentLabel.snp.makeConstraints { make in
               if feedAdData.metaTitle() != nil {
                   make.top.equalTo(metaTitleLabel.snp.bottom).offset(10)
               } else if feedAdData.metaIcon() != nil {
                   make.centerY.equalTo(iconImageView!)
               } else {
                   make.top.equalTo(self).offset(10)
               }
               make.right.lessThanOrEqualTo(closeBtn.snp.left).offset(-10)
               make.left.equalTo(feedAdData.metaIcon() != nil ? iconImageView!.snp.right : self).offset(20)
            }
            clickViews.append(self.metaContentLabel)
        } else {
            metaContentLabel.isHidden = true
        }
        if feedAdData.metaCreativeType() == .image || feedAdData.metaCreativeType() == .largeImage {
            let adImageView:UIImageView = imgViews[0]
            adImageView.snp.makeConstraints { make in
                if self.feedAdData.metaIcon() != nil {
                    make.top.equalTo(iconImageView!.snp.bottom).offset(10)
                } else if feedAdData.metaContent() != nil {
                    make.top.equalTo(metaContentLabel.snp.bottom).offset(10)
                } else if feedAdData.metaTitle() != nil {
                    make.top.equalTo(metaTitleLabel.snp.bottom).offset(10)
                }else {
                    make.top.equalTo(self).offset(10)
                }
                make.left.equalTo(self).offset(20)
                make.right.equalTo(self).offset(-20)
                make.bottom.equalTo(self).offset(-30)
            }
        } else if feedAdData.metaCreativeType() == .smallImage {
            self.iconImageView?.isHidden = true
            let adImageView:UIImageView = imgViews[0]
            adImageView.snp.makeConstraints { make in
                make.width.equalTo(150)
                make.top.equalTo(self).offset(10)
                make.left.equalTo(self).offset(20)
                make.bottom.equalTo(self).offset(-30)
            }
            if feedAdData.metaTitle() != nil {
                self.metaTitleLabel.snp.remakeConstraints { make in
                    make.right.equalTo(self).offset(-20)
                    make.top.equalTo(adImageView.snp.top)
                    make.left.equalTo(adImageView.snp.right).offset(10)
                }
            }
            if feedAdData.metaContent() != nil {
                metaContentLabel.snp.remakeConstraints { make in
                    if feedAdData.metaTitle() != nil {
                        make.top.equalTo(metaTitleLabel.snp.bottom)
                    } else {
                        make.top.equalTo(adImageView.snp.top)
                    }
                    make.right.equalTo(self).offset(-20)
                    make.left.equalTo(adImageView.snp.right).offset(10)
                }
            }
        } else if feedAdData.metaCreativeType() == .threeImage {
            if imgViews.count >= 2 {
                let tempWidth:CGFloat = self.bounds.size.width / CGFloat(imgViews.count)
                let img1:UIImageView = imgViews[0]
                let img2:UIImageView = imgViews[1]
                var img3:UIImageView?
                if imgViews.count == 3 {
                    img3 = imgViews[2]
                }
                img1.snp.makeConstraints { make in
                    if feedAdData.metaIcon() != nil {
                        make.top.equalTo(iconImageView!.snp.bottom).offset(10)
                    } else if feedAdData.metaContent() != nil {
                        make.top.equalTo(metaContentLabel.snp.bottom).offset(10)
                    } else if feedAdData.metaTitle() != nil {
                        make.top.equalTo(metaTitleLabel.snp.bottom).offset(10)
                    }else {
                        make.top.equalTo(self).offset(10)
                    }
                    make.left.equalTo(self)
                    make.height.equalTo(100)
                    make.width.equalTo(tempWidth)
                }
                img2.snp.makeConstraints { make in
                    make.height.equalTo(100)
                    make.width.equalTo(tempWidth)
                    make.left.equalTo(img1.snp.right)
                    make.top.equalTo(img1.snp.top)
                }
                if img3 != nil {
                    img3!.snp.makeConstraints { make in
                        make.height.equalTo(100)
                        make.width.equalTo(tempWidth)
                        make.left.equalTo(img2.snp.right)
                        make.top.equalTo(img1.snp.top)
                    }
                }
            } else if self.imgViews.count == 1 {
                let adImageView:UIImageView = imgViews[0]
                adImageView.snp.makeConstraints { make in
                    if feedAdData.metaIcon() != nil {
                        make.top.equalTo(iconImageView!.snp.bottom).offset(10)
                    } else if feedAdData.metaContent() != nil {
                        make.top.equalTo(metaContentLabel.snp.bottom).offset(10)
                    } else if feedAdData.metaTitle() != nil {
                        make.top.equalTo(metaTitleLabel.snp.bottom).offset(10)
                    } else {
                        make.top.equalTo(self).offset(10)
                    }
                    make.left.equalTo(self).offset(20)
                    make.right.equalTo(self).offset(-20)
                    make.bottom.equalTo(self).offset(-30)
                }
            }
        }
        if feedAdData.metaSource() != nil {
            metaSourceLabel!.snp.makeConstraints { make in
                make.width.lessThanOrEqualTo(100)
                make.left.equalTo(self).offset(20)
                make.bottom.equalTo(self).offset(-5)
            }
            clickViews.append(metaSourceLabel!)
        } else {
            metaSourceLabel?.isHidden = true
        }
        if feedAdData.metaActionTitle() != nil {
            metaActionLabel?.snp.makeConstraints({ make in
                make.bottom.equalTo(self).offset(-5)
                make.width.lessThanOrEqualTo(100)
                make.left.equalTo(feedAdData.metaActionTitle() != nil ? metaSourceLabel!.snp.right : self).offset(20)
            })
            clickViews.append(metaActionLabel!)
        } else {
            metaActionLabel?.isHidden = true
        }
    }
    //获取可点击子控件
    func customImageAdViewClickViews() -> Array<UIView> {
        for view in imgViews {
            clickViews.append(view)
        }
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
    //关闭回调
    @objc func closeAd(){
//        if shakeTwist != nil {
//            destoryInteraction()
//        }
        clickViews.removeAll()
        destoryNativeCustomAdView()
        if delegate != nil {
            delegate?.nativeSimpleImageAdViewClosed(adView: self)
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
        var tempHeight:CGFloat = 300
        if feedAd.metaCreativeType() == .threeImage && feedAd.metaImageUrls()?.count ?? 0 >= 2 {
            tempHeight = 200
            if feedAd.metaSource() != nil || feedAd.metaActionTitle() != nil {
                tempHeight += 30
            }
        } else if feedAd.metaCreativeType() == .smallImage {
            tempHeight = 200
        }
        return tempHeight
    }
}
