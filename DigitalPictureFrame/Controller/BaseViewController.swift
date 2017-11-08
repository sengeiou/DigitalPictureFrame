//
//  BaseViewController.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek on 11/2/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, ViewSetupable {
  @IBOutlet weak var tableView: UITableView!
  
  let sharedAlert = AlertViewPresenter.sharedInstance
  var dataSourceDelegate: DigitalPictureFrameDataSourceDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupStyle()
  }
}


// MARK: - ViewSetupable protocol
extension BaseViewController {
  
  func setup() {
    // TODO: Override in subclass
  }
  
  func setupStyle() {
    tableView.separatorStyle = .none
  }
  
}



// MARK: - Reload Rows
extension BaseViewController {
  
  func reloadRows(at indexPaths: IndexPath...) {
    tableView.beginUpdates()
    tableView.reloadRows(at: indexPaths, with: .fade)
    tableView.endUpdates()
  }
  
}


// MARK: - Create assign delegate
extension BaseViewController {
  
  func createAndAssignDelegate(for items: DigitalPictureFrameItem) {
    let infoItem = [items]
    
    if let dataSourceDelegate = dataSourceDelegate {
      dataSourceDelegate.items = infoItem
      tableView.reloadData()
    } else {
      dataSourceDelegate = DigitalPictureFrameDataSource(self, items: infoItem)
      tableView.dataSource = dataSourceDelegate
      tableView.delegate = dataSourceDelegate
    }
  }
  
}


// Show No reports available message
fileprivate extension BaseViewController {
  
  func showNoReportsAvailableMessage() {
    removeTableViewEmptyCells()
    
    let messageHeight = CGFloat(25)
    let xPos = CGFloat(0)
    let yPos = (tableView.frame.size.height - (messageHeight * 2)) / 2
    let width = tableView.frame.size.width
    let titleMessage = "No data available"
    let subtitleMessage = "Pull to refresh"
    
    let frame = CGRect(x: xPos, y: yPos, width: width, height: messageHeight * 2)
    let availabilityMessage = AvailabilityMessageView(frame: frame, titles: titleMessage, subtitleMessage)
    tableView.addSubview(availabilityMessage)
  }
  
  
  func removeTableViewEmptyCells() {
    tableView.tableFooterView = UIView()
  }
  
}



// MARK: - Hide No Reports Available Message If Visible
extension BaseViewController {
  
  func hideAvailabilityMessageView() {
    guard let availabilityMessageView = tableView.viewWithTag(EmbeddedViewTag.availabilityMessage.rawValue) else { return }
    availabilityMessageView.removeFromSuperview()
  }
  
}


