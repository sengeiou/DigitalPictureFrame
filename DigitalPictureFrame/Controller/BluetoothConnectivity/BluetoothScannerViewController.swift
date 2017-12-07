//
//  BluetoothScannerViewController.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit

class BluetoothScannerViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  private var dataSourceDelegate: BluetoothConnectivityDataSourceDelegate?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
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
extension BluetoothScannerViewController: ViewSetupable {
  
  func setup() {
    dataSourceDelegate = BluetoothConnectivityDataSource(self, items: [])
    tableView.dataSource = dataSourceDelegate
    tableView.delegate = dataSourceDelegate
  }
  
}
