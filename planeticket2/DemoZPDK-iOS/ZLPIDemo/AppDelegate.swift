//
//  AppDelegate.swift
//  ZLPIDemo
//
//  Created by Nguyen Cong Tuan Huy on 7/30/19.
//  Copyright © 2019 Nguyen Cong Tuan Huy. All rights reserved.
//

import UIKit
import zpdk
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ZaloPaySDK.sharedInstance()?.initWithAppId(2554, uriScheme: "demozpdk://app", environment: .sandbox)
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ZaloPaySDK.sharedInstance().application(app, open: url, sourceApplication:"vn.com.vng.zalopay", annotation: nil)
    }
}

