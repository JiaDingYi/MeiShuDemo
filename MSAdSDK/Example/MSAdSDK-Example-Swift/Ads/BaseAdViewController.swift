//
//  BaseAdViewController.swift
//  MSAdSDK-Example-Swift
//
//  Created by MSAdSDK on 2023/7/19.
//  Copyright © 2023 MSAdSDK. All rights reserved.
//

import UIKit

class BaseAdViewController: UIViewController {
    public var pid:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    public func logAdInfo(string:String){
        print("【广告信息】\(string)")
    }
}
