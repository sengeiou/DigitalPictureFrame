//
//  BluetoothConnectivityViewController+Actions.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import KYCircularProgress

extension BluetoothConnectivityViewController {
  
  @IBAction func sendJSONButtonPressed(_ sender: UIButton) {
    let circularProgress = KYCircularProgress(frame: sender.bounds, showGuide: true)
    circularProgress.progressChanged {
      (progress: Double, circularProgress: KYCircularProgress) in
      print("progress: \(progress)")
    }
    
    sender.addSubview(circularProgress)
    
    if !sharedInstance.serial.isReady {
      let title = "Not connected"
      let message = "No bluetooth connected"
      AlertViewPresenter.sharedInstance.presentPopupAlert(in: self, title: title, message: message)
    } else {
      let msg = "TEST MESSAGE"
      sharedInstance.serial.sendMessageToDevice(msg)
    }

  }
  
  
  @IBAction func scanDevicesButtonPressed(_ sender: UIButton) {
    if sharedInstance.serial.connectedPeripheral == nil {
      startScanningIndicatorAnimating()
      sharedInstance.serial.startScan()
      connectedPeripheralLabel.text = "Scanning..."
      searchDevicesButton.isEnabled = false
      Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(BluetoothConnectivityViewController.scanTimeOut),
                           userInfo: nil, repeats: false)
      
    } else {
      sharedInstance.serial.disconnect()
      reloadView()
    }
  }
  
  
  @objc func scanTimeOut() {
    sharedInstance.serial.stopScan()
    searchDevicesButton.isEnabled = true
    connectedPeripheralLabel.text = "Done scanning"
    stopScanningIndicatorAnimating()
  }
  
}
