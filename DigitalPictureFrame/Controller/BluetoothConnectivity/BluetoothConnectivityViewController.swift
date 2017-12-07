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
    setupStyle()
  }


  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
}


// MARK: - ViewSetupable protocol
extension BluetoothConnectivityViewController: ViewSetupable {
  
  func setup() {
    searchDevicesButton.setTitle("Serach Devices", for: .normal)
    sendJSONFileButton.setTitle("Send JSON", for: .normal)
    
    dataSourceDelegate = BluetoothConnectivityDataSource(self, items: [])
    tableView.dataSource = dataSourceDelegate
    tableView.delegate = dataSourceDelegate
  }

  
  func setupStyle() {
    typealias BluetoothStyle = Style.BluetoothConnectivityVC
    BluetoothStyle.roundCorners(for: searchDevicesButton, sendJSONFileButton)
  }
  
}


// MARK: -
extension BluetoothConnectivityViewController {
  
}
