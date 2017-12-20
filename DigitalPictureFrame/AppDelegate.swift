//
//  AppDelegate.swift
//  Digital Picture Frame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
//    renderStatusBarBackgroundColor()
    return true
  }
}


// MARK: - Render StatusBar background color
private extension AppDelegate {
  
  func renderStatusBarBackgroundColor() {
    UIApplication.shared.isStatusBarHidden = false
    UIApplication.shared.statusBarStyle = UIStatusBarStyle.default

    let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
    statusBar.backgroundColor = UIColor.groupGray
  }
  
}
