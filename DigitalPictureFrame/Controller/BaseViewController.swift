//
//  BaseViewController.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController, ViewSetupable {
  @IBOutlet weak var tableView: UITableView!
  
  private var refreshControl: UIRefreshControl = {
    let refreshCtrl = UIRefreshControl()
    let attributes = [NSAttributedStringKey.foregroundColor: UIColor.appleBlue]
    let title = NSAttributedString(string: "Retrieving Data", attributes: attributes)
    refreshCtrl.attributedTitle = title
    refreshCtrl.tintColor = UIColor.appleBlue
    refreshCtrl.addTarget(self, action: #selector(BaseViewController.refreshData(_:)), for: .valueChanged)
    return refreshCtrl
  }()
  
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
  
  deinit {
    unregisterNotifications()
  }
}


// MARK: - ViewSetupable protocol
extension BaseViewController {
  
  func setup() {
    // TODO: Override in subclass
    tableView.refreshControl = refreshControl
    registerNotifications()
  }
  
  func setupStyle() {
    tableView.separatorStyle = .none
  }
}


// MARK: - Reload Rows
extension BaseViewController {
  func registerNotifications() {
    addReloadDataNofificationObserver()
    addEndRefreshingIndicatorNofificationObserver()
  }
  
  func unregisterNotifications() {
    removeReloadDataNofificationObserver()
    removeEndRefreshingIndicatorNofificationObserver()
  }
  
  
  func addReloadDataNofificationObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.reloadData),
                                           name: NotificationName.reloadData.name, object: nil)
  }
  
  func removeReloadDataNofificationObserver() {
    NotificationCenter.default.removeObserver(self, name: NotificationName.reloadData.name, object: nil)
  }
  
  func addEndRefreshingIndicatorNofificationObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.endRefreshingIndicator),
                                           name: NotificationName.endRefreshingIndicator.name, object: nil)
  }
  
  func removeEndRefreshingIndicatorNofificationObserver() {
    NotificationCenter.default.removeObserver(self, name: NotificationName.endRefreshingIndicator.name, object: nil)
  }
  
  @objc func reloadData() {
    // TODO: Override in subclass
  }
  
  @objc func refreshData(_ sender: Any) {
    NotificationCenter.default.post(name: NotificationName.refreshData.name, object: nil)
  }
  
  
  @objc func endRefreshingIndicator() {
    refreshControl.endRefreshing()
  }
}


// MARK: - Reload Rows
extension BaseViewController {
  
  func updateTableView() {
    if let dataSourceDelegate = dataSourceDelegate, dataSourceDelegate.numberOfSections > 0 {
      hideNodataAvailableMessage()
    } else {
      showNoDataAvailableMessage()
    }
    
    tableView.reloadData()
  }
  
  
  func reloadRows(at indexPaths: IndexPath...) {
    tableView.beginUpdates()
    tableView.reloadRows(at: indexPaths, with: .fade)
    tableView.endUpdates()
  }
  
}


// MARK: - Create assign delegate
extension BaseViewController {
  
  func clearDataSource() {
    createAndAssignDelegate(for: nil)
  }
  
  
  func createAndAssignDelegate(for items: [DigitalPictureFrameItem]?) {
    if let dataSourceDelegate = dataSourceDelegate {
      dataSourceDelegate.items = items
    } else {
      dataSourceDelegate = DigitalPictureFrameDataSource(self, items: items)
      tableView.dataSource = dataSourceDelegate
      tableView.delegate = dataSourceDelegate
    }
  }
  
}


// Show/Hide No data available message
extension BaseViewController {
  
  var isAvailableMessageVisible: Bool {
    if let _ = tableView.viewWithTag(EmbeddedViewTag.availabilityMessage.rawValue) {
      return true
    }
    
    return false
  }
  
  func showNoDataAvailableMessage() {
    guard !isAvailableMessageVisible else { return }
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
  
  
  func hideNodataAvailableMessage() {
    guard isAvailableMessageVisible else { return }
    let availabilityMessageView = tableView.viewWithTag(EmbeddedViewTag.availabilityMessage.rawValue)
    availabilityMessageView?.removeFromSuperview()
  }
  
  
  func removeTableViewEmptyCells() {
    tableView.tableFooterView = UIView()
  }
}
