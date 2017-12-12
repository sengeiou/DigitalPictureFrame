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
      let title = NSLocalizedString("BLUETOOTH_CONNECTIVITY_ALERT_TITLE_NOT_CONNECTED", comment: "")
      let message = NSLocalizedString("BLUETOOTH_CONNECTIVITY_ALERT_MESSAGE_NOT_CONNECTED", comment: "")
      AlertViewPresenter.sharedInstance.presentPopupAlert(in: self, title: title, message: message)
    } else {
      let msg = "TEST MESSAGE"
      sharedInstance.serial.sendMessageToDevice(msg)
    }

  }
  
  
  @IBAction func scanDevicesButtonPressed(_ sender: UIButton) {
    if !sharedInstance.serial.isConnectedToPeripheral {
      clearPeripherals()
      hideNoPeripheralsAvailableMessage()
      startScanningIndicator()
      sharedInstance.serial.startScan()
      connectivityTitleLabel.text = NSLocalizedString("BLUETOOTH_CONNECTIVITY_LABEL_TITLE_SCANNING", comment: "")
      searchDevicesButton.isEnabled = false
      scheduleTimerForScanTimeOut()
      
    } else {
      sharedInstance.serial.disconnect()
      reloadView()
    }
  }

}
