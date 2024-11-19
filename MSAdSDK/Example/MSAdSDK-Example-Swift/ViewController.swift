//
//  ViewController.swift
//  MSAdSDK-Example-Swift
//
//  Created by MSAdSDK on 2023/7/19.
//  Copyright © 2023 MSAdSDK. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    private var tableView:UITableView!
    private let reusableTableViewCellID = "NormalTableIdentifier"
    private var adTypeArr:Array<String> = ["开屏广告","插屏广告","横幅广告","draw广告","信息流广告","全屏视频广告","激励视频广告"]
    private var dataSource:Array<String> = ["73646b0499001991","73646b0599001991","73646b0399001991",
                                            "73646b0799001991","73646b1099911991","73646b0799001991","73646b0799001991"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView.init(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adTypeArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableTableViewCellID) ?? UITableViewCell.init(style: .default, reuseIdentifier: reusableTableViewCellID)
        cell.textLabel?.text = adTypeArr[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc: BaseAdViewController?
        switch indexPath.row {
        case 0:
            vc = SplashAdViewController()
        case 1:
            vc = InterstiitialAdViewController()
        case 2:
            vc = BannerAdViewController()
        case 3:
            vc = DrawAdViewController()
        case 4:
            vc = NativeExpressAdViewController()
        case 5:
            vc = FullVideoAdViewController()
        case 6:
            vc = RewardAdViewController()
        default:
            vc = nil
        }
        vc?.pid = dataSource[indexPath.row]
        vc?.title = adTypeArr[indexPath.row]
        if let viewVc = vc {
            self.navigationController?.pushViewController(viewVc, animated: true)
        } else {
            print("vc初始化失败")
        }
    }
}

