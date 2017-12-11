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
import MBProgressHUD

extension BluetoothConnectivityViewController {
  
  @IBAction func sendJSONButtonPressed(_ sender: UIButton) {
//    let circularProgress = KYCircularProgress(frame: sender.bounds, showGuide: true)
//    circularProgress.progressChanged {
//      (progress: Double, circularProgress: KYCircularProgress) in
//      print("progress: \(progress)")
//    }
//
//    sender.addSubview(circularProgress)
    
    if !sharedInstance.serial.isReady {
      let title = "Not connected"
      let message = "No bluetooth connected"
      AlertViewPresenter.sharedInstance.presentPopupAlert(in: self, title: title, message: message)
    } else {
//      let msg = "TEST MESSAGE"
//      sharedInstance.serial.sendMessageToDevice(msg)
      MBProgressHUD.showHUD(in: view, with: "Peripheral is Ready. Sending file not implemented.")
    }

  }
  
  
  @IBAction func scanDevicesButtonPressed(_ sender: UIButton) {
    if !sharedInstance.serial.isConnectedToPeripheral {
      clearPeripherals()
      hideNoPeripheralsAvailableMessage()
      startScanningIndicator()
      sharedInstance.serial.startScan()
      connectedPeripheralLabel.text = "Scanning..."
      searchDevicesButton.isEnabled = false
      scheduleTimerForScanTimeOut()
      
    } else {
      sharedInstance.serial.disconnect()
      reloadView()
    }
  }

}
