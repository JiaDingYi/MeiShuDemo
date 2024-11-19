//
//  AppDelegate.swift
//  MSAdSDK-Example-Swift
//
//  Created by MSAdSDK on 2023/7/19.
//  Copyright © 2023 MSAdSDK. All rights reserved.
//

import UIKit
import MSAdSDK
import AppTrackingTransparency

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        let nav = UINavigationController.init(rootViewController: ViewController())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        startSDK()
        if #available(iOS 14, *) {
            ATTrackingManager .requestTrackingAuthorization { status in
                
            }
        } else {
            
        }
        return true
    }
    //初始化SDK，在block中进行个性化配置 
    func startSDK() {
        MSAdSDK.start(withAppid: "101647") {
            MSAdSDK.setLogLevel(MSLogNone)
            //支持微信小程序跳转
//            MSConfig.setWXAppId("", universalLink: "")
        }
    }

}

