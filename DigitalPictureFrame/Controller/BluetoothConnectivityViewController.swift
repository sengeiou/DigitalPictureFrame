//
//  BluetoothConnectivityViewController.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit
import ConcentricProgressRingView

class BluetoothConnectivityViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchDevicesButton: UIButton!
  @IBOutlet weak var sendJSONFileButton: UIButton!
  
  private var dataSourceDelegate: BluetoothConnectivityDataSourceDelegate?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupLayout()
    setupStyle()
  }


}


// MARK: - ViewSetupable protocol
extension BluetoothConnectivityViewController: ViewSetupable {
  
  func setup() {
    dataSourceDelegate = BluetoothConnectivityDataSource(self, items: [])
    tableView.dataSource = dataSourceDelegate
    tableView.delegate = dataSourceDelegate
  }
  
  
  func setupLayout() {
    searchDevicesButton.setTitle("Serach Devices", for: .normal)
    sendJSONFileButton.setTitle("Send JSON", for: .normal)
  }
  
  
  func setupStyle() {
    typealias BluetoothStyle = Style.BluetoothConnectivityVC
    BluetoothStyle.roundCorners(for: searchDevicesButton, sendJSONFileButton)
  }
  
}


// MARK: -
extension BluetoothConnectivityViewController {
  
}
