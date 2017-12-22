//
//  PageContentViewController.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PageContentViewController: UIViewController, ViewSetupable {
  @IBOutlet weak var tableView: UITableView!
  
  private var refreshControl: UIRefreshControl = {
    let refreshCtrl = UIRefreshControl()
    refreshCtrl.tintColor = UIColor.appleBlue
    refreshCtrl.addTarget(self, action: #selector(PageContentViewController.refreshData(_:)), for: .valueChanged)
    return refreshCtrl
  }()
  
  let sharedAlert = AlertViewPresenter.sharedInstance
  var dataSourceDelegate: DigitalPictureFrameDataModelDelegate?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupStyle()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setupLayout()
  }
  
  deinit {
    unregisterNotifications()
  }
}


// MARK: - ViewSetupable protocol
extension PageContentViewController {
  
  func setup() {
    // TODO: Override in subclass
    tableView.refreshControl = refreshControl
    registerNotifications()
  }
  
  func setupStyle() {
    tableView.separatorStyle = .none
  }
  
  func setupLayout() { }
}


// MARK: - Reload Rows
extension PageContentViewController {
  func registerNotifications() {
    addReloadDataNofificationObserver()
    addEndRefreshingIndicatorNofificationObserver()
  }
  
  func unregisterNotifications() {
    removeReloadDataNofificationObserver()
    removeEndRefreshingIndicatorNofificationObserver()
  }
  
  
  func addReloadDataNofificationObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(PageContentViewController.reloadData),
                                           name: NotificationName.reloadData.name, object: nil)
  }
  
  func removeReloadDataNofificationObserver() {
    NotificationCenter.default.removeObserver(self, name: NotificationName.reloadData.name, object: nil)
  }
  
  func addEndRefreshingIndicatorNofificationObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(PageContentViewController.endRefreshingIndicator),
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
extension PageContentViewController {
  
  func updateTableView() {
    func removeTableViewEmptyCells() {
      tableView.tableFooterView = UIView()
    }
    
    var shouldShowNoDataAvailableMessage: Bool {
      return dataSourceDelegate?.numberOfSections == 0 ? true : false
    }
    
    
    if shouldShowNoDataAvailableMessage {
      showNoDataAvailableMessage()
      removeTableViewEmptyCells()
    } else {
      hideNoDataAvailableMessage()
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
extension PageContentViewController {
  
  func clearDataSource() {
    createAndAssignDelegate(for: nil)
  }
  
  
  func createAndAssignDelegate(for items: [DigitalPictureFrameItem]?) {
    if let dataSourceDelegate = dataSourceDelegate {
      dataSourceDelegate.items = items
    } else {
      dataSourceDelegate = DigitalPictureFrameDataModel(self, items: items)
      tableView.dataSource = dataSourceDelegate
      tableView.delegate = dataSourceDelegate
    }
  }
  
}


// Show/Hide No data available message
extension PageContentViewController {
  
  func showNoDataAvailableMessage() {
    let title = NSLocalizedString("PAGE_CONTENT_NO_DATA_AVAILABLE_TITLE", comment: "")
    let subtitle = NSLocalizedString("PAGE_CONTENT_NO_DATA_AVAILABLE_SUBTITLE", comment: "")
    AvailabilityMessageView.show(on: tableView, title: title, subtitle: subtitle)
  }
  
  
  func hideNoDataAvailableMessage() {
    AvailabilityMessageView.hide()
  }

}
