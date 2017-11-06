//
//  DigitalPictureFrameViewController.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/4/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class DigitalPictureFrameViewController: UITabBarController, UITabBarControllerDelegate, ViewSetupable {
  @IBOutlet weak var topTabBar: UITabBar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setupLayout()
  }
}


// MARK: - ViewSetupable protocol
extension DigitalPictureFrameViewController {
  
  func setup() {
    delegate = self
  }
  
  
  func setupLayout() {
    func moveTabBarToTopOfScreen() {
      let statusBarHeight = UIApplication.shared.statusBarFrame.height
      let tabYPos = view.frame.origin.y + statusBarHeight
      var tabFrame = topTabBar.frame
      
      tabFrame.origin.y = tabYPos
      topTabBar.frame = tabFrame
    }
    
    moveTabBarToTopOfScreen()
  }
}


// MARK: - UITabBarControllerDelegate protocol
extension DigitalPictureFrameViewController {
  
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    guard let selectedTab = tabBarController.tabBar.selectedItem?.tag,
          let selectedType = TopTabBarItemType(rawValue: selectedTab) else { return }

    switch selectedType {
    case .users where viewController is UserViewController:
      let vc = viewController as! UserViewController
      vc.users = DatabaseSingleton.shared.data?.users
      print(selectedType.description) // add notification center to reload data in VC!!

    case .settings where viewController is SettingsViewController:
      let vc = viewController as! SettingsViewController
      vc.settings = DatabaseSingleton.shared.data?.settings
      vc.tableView.reloadData()
      print(selectedType.description) // add notification center to reload data in VC!!

    case .wifi where viewController is WiFiViewController:
      let vc = viewController as! WiFiViewController
      vc.wifiInfo = DatabaseSingleton.shared.data?.wifiInfo
      vc.tableView.reloadData()
      print(selectedType.description) // add notification center to reload data in VC!!
      
    default:
      break
    }
    
  }
}
