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
    guard let selectedTag = tabBarController.tabBar.selectedItem?.tag,
          let selectedType = TopTabBarItemType(rawValue: selectedTag) else { return }
    
    switch selectedType {
    case .users:
      print(selectedType.description)
      
    case .settings:
      print(selectedType.description)
      
    case .wifi:
      print(selectedType.description)
    }
  }
}
