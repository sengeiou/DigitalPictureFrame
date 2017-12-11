//
//  ContainerViewController.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
  @IBOutlet weak var customTabBarView: UIView!

  lazy private var tabBar: CustomTabBar = {
    let tabbar = CustomTabBar(frame: self.customTabBarView.frame)
    tabbar.dataSource = self
    tabbar.delegate = self
    tabbar.setup()
    return tabbar
  }()
  
  lazy private var tabBarItems: [CustomTabBarItem] = {
    let users = CustomTabBarItem(image: TopTabBarItemType.users.icon, title: TopTabBarItemType.users.description)
    let settings = CustomTabBarItem(image: TopTabBarItemType.settings.icon, title: TopTabBarItemType.settings.description)
    let wifi = CustomTabBarItem(image: TopTabBarItemType.wifi.icon, title: TopTabBarItemType.wifi.description)
    let bluetooth = CustomTabBarItem(image: TopTabBarItemType.bluetoothConnectivity.icon, title: TopTabBarItemType.bluetoothConnectivity.description)
    return [users, settings, wifi, bluetooth]
  }()
  
  var turningPageDelegate: ContainerViewControllerDelegate?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    selectFirstItem()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setupLayout()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier, identifier == SegueIdentifierType.digitalPictureFramePageSegue.rawValue else { return }
    let destinationVC = segue.destination as! DigitalPictureFramePageViewController
    turningPageDelegate = destinationVC
  }
  
  deinit {
    unregisterNotification()
  }
}


// MARK: - ViewSetupable protocol
extension ContainerViewController: ViewSetupable {
  
  func setup() {
    registerNotification()
  }
  
  func setupLayout() {
    renderStatusBarBackgroundColor()
    view.addSubview(tabBar)
  }
}


// MARK: - Select first item and change StatusBar color
private extension ContainerViewController {
  
  func selectFirstItem() {
    tabBarItems.first!.sendActions(for: .touchUpInside)
  }
  
  func renderStatusBarBackgroundColor() {
    let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
    let statusBarColor = UIColor.groupGray
    statusBarView.backgroundColor = statusBarColor
    view.addSubview(statusBarView)
  }
  
}


// MARK: - Add Notification Observer
extension ContainerViewController {
  
  func registerNotification() {
    addItemSelectedAtIndexNofificationObserver()
  }
  
  func unregisterNotification() {
    removeItemSelectedAtIndexNofificationObserver()
  }
  
  
  func addItemSelectedAtIndexNofificationObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(ContainerViewController.itemSelected(_:)),
                                           name: NotificationName.tabBarItemSelectedAtIndex.name, object: nil)
  }
  
  func removeItemSelectedAtIndexNofificationObserver() {
    NotificationCenter.default.removeObserver(self, name: NotificationName.tabBarItemSelectedAtIndex.name, object: nil)
  }
  
  
  @objc func itemSelected(_ notification: NSNotification) {
    guard let currentPageIndex = notification.userInfo?[NotificationUserInfoKey.currentPageIndex.rawValue] as? Int else { return }
    tabBarItems[currentPageIndex].sendActions(for: .touchUpInside)
  }
  
}


// MARK: - CustomTabBarDataSource protocol
extension ContainerViewController: CustomTabBarDataSource {
  
  func tabBarItems(in CustomTabBar: CustomTabBar) -> [CustomTabBarItem] {
    return tabBarItems
  }
  
}

// MARK: - CustomTabBarDelegate protocol
extension ContainerViewController: CustomTabBarDelegate {
  
  func customTabBar(_ customTabBar: CustomTabBar, didSelectTabBarButtonAt index: Int) {
    turningPageDelegate?.containerViewController(self, didSelectPageAt: index)
  }
  
}

