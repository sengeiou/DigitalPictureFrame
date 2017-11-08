//
//  DigitalPictureFrameViewController.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/4/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class DigitalPictureFrameViewController: UITabBarController, UITabBarControllerDelegate, ViewSetupable {
  private var shared: DatabaseManager?
  lazy private var progressIndicator: ProgressIndicator = {
    let progress = ProgressIndicator(text: "Loading")
    self.view.addSubview(progress)
    return progress
  }()
  
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
    loadData()
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


// MARK: - Load data
private extension DigitalPictureFrameViewController {
  
  func loadData() {
    progressIndicator.show()
    NetworkManager.shared.fetchData(completionHandler: {[unowned self] result in
      switch result {
      case .success(let decodeData):
        let _ = DatabaseManager.shared(data: decodeData)
        self.sendNotificationToReloadUserData()
        self.progressIndicator.hide()
        
      case .failure(let error):
        self.progressIndicator.hide()
        AlertViewPresenter.sharedInstance.presentErrorAlert(in: self, error: error)
        
      }
    })
  }
  
  func sendNotificationToReloadUserData() {
    NotificationCenter.default.post(name: NotificationName.reloadDataInUserViewController.name, object: nil)
  }
}


// MARK: - UITabBarControllerDelegate protocol
extension DigitalPictureFrameViewController {
  
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    guard let selectedTab = tabBarController.tabBar.selectedItem?.tag,
          let selectedType = TopTabBarItemType(rawValue: selectedTab) else { return }

    switch selectedType {
    case .users where viewController is UserViewController:
      print(selectedType.description)

    case .settings where viewController is SettingsViewController:
      print(selectedType.description) // add notification center to reload data in VC!!

    case .wifi where viewController is WiFiViewController:
      print(selectedType.description) // add notification center to reload data in VC!!
      
    default:
      break
    }
    
  }
}
