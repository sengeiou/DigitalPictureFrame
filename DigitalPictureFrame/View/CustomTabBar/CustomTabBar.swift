//
//  CustomTabBar.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class CustomTabBar: UIView {
  private var items: [CustomTabBarItem]!
  var dataSource: CustomTabBarDataSource?
  var delegate: CustomTabBarDelegate?
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


// MARK: - ViewSetupable protocol
extension CustomTabBar: ViewSetupable {

  func setup() {
    items = dataSource?.tabBarItems(in: self)
    let containers = createTabBarItemContainers()
    createTabBarItems(for: containers)
    setupStyle()
  }
  
  func setupStyle() {
    backgroundColor = UIColor.groupGray
  }
}


// MARK: - Create TabBarItems
private extension CustomTabBar {
  
  func createTabBarItemContainers() -> [CGRect] {
    guard let items = items else { return [] }
    var containerArray = [CGRect]()
    
    for index in 0..<items.count {
      let tabBarContainer = createTabBarContainer(at: index)
      containerArray.append(tabBarContainer)
    }
    
    return containerArray
  }
  
  func createTabBarContainer(at index: Int) -> CGRect {
    let width = frame.width / CGFloat(items.count)
    let height = frame.height
    let tabBarContainerRect = CGRect(x: width * CGFloat(index), y: 0, width: width, height: height)
    return tabBarContainerRect
  }
  
  
  func createTabBarItems(for containers: [CGRect]) {
    for (index, item) in items.enumerated() {
      let container = containers[index]
      item.frame = container
      item.delegate = self
      item.setup()
      
      addSubview(item)
    }
  }
}


// MARK: - CustomTabBarItemDelegate protocol
extension CustomTabBar: CustomTabBarItemDelegate {
  
  func customTabBarItemDidSelect(_ customTabBarItem: CustomTabBarItem) {
    clearState()
    let selectedIndex = items.index(of: customTabBarItem)!
    delegate?.customTabBar(self, didSelectTabBarButtonAt: selectedIndex)
  }
  
  private func clearState() {
    items.forEach { $0.isSelected = false }
  }
}
