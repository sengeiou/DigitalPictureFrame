//
//  LoggerView.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class LoggerView: UIView {
  static private let shared = LoggerView()
  
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var logTextView: UITextView!
  
  private init() {
    super.init(frame: .zero)
    self.setup()
    self.setupStyle()
  }
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
    self.setupStyle()
  }

  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setup()
    self.setupStyle()
  }
  
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    logTextView.text = Logger.stringRepresentation
  }
}


// MARK: - ViewSetupable protocol
extension LoggerView: ViewSetupable {
  
  func setup() {
    loadFromNib()
    logTextView.isEditable = false
    logTextView.showsHorizontalScrollIndicator = false
  }
  
  func setupStyle() {
    setupNavigationBar()
    renderLogTextView()
  }
  
}


// MARK: - Load from Nib
private extension LoggerView {
  
  func loadFromNib() {
    Bundle.main.loadNibNamed(LoggerView.nibName, owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
  }
  
}


// MARK: - Render titles
private extension LoggerView {
  
  func setupNavigationBar() {
    typealias StatusBarStyle = Style.StatusBarView
    navigationBar.barTintColor = StatusBarStyle.backgroundColor
    navigationBar.titleTextAttributes = StatusBarStyle.titleTextAttributes
    navigationBar.topItem?.title = NSLocalizedString("BLUETOOTH_LOGGER_NAVIGATIONBAR_TITLE", comment: "")
  }
  
  func renderLogTextView() {
    typealias LogViewStyle = Style.LoggerView
    backgroundColor = LogViewStyle.defaultBackgroundColor
    
    logTextView.backgroundColor = LogViewStyle.logTextViewBackground
    logTextView.textColor = LogViewStyle.logTextViewTextColor
    logTextView.font = LogViewStyle.logTextViewFont
  }
}

// MARK: - Actions
extension LoggerView {
  
  @IBAction func backBarItemPressed(_ sender: UIBarButtonItem) {
    LoggerView.dismiss()
  }
  
  
  @IBAction func sendEmailButtonPressed(_ sender: UIBarButtonItem) {
    guard MFMailComposeViewController.canSendMail() else {
      let errorMessage = NSLocalizedString("LOGGER_VIEW_MAIL_NOT_AVAILABLE_ALERT_MSG", comment: "")
      AlertViewPresenter.sharedInstance.presentErrorAlert(withMessage: errorMessage)
      return
    }
    
    guard let topViewController = UIApplication.topViewController else {
      let errorMessage = NSLocalizedString("LOGGER_VIEW_TOP_VIEW_CONTROLLER_NOT_AVAILABLE_ALERT_MSG", comment: "")
      AlertViewPresenter.sharedInstance.presentErrorAlert(withMessage: errorMessage)
      return
    }
    
    let composeVC = MFMailComposeViewController()
    let subjectTitle = NSLocalizedString("LOGGER_VIEW_MAIL_SUBJECT_TITLE", comment: "")
    let recipientsMail = ["pawel.milek0626@gmail.com"]
    
    composeVC.mailComposeDelegate = self
    composeVC.setToRecipients(recipientsMail)
    composeVC.setSubject(subjectTitle)
    composeVC.setMessageBody(logTextView.text, isHTML: false)
    
    topViewController.present(composeVC, animated: true, completion: nil)
    LoggerView.dismiss()
  }
  
}


// MARK: - MFMailComposeViewControllerDelegate protocol
extension LoggerView: MFMailComposeViewControllerDelegate {
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    var logMessage = ""
    
    switch result {
    case .cancelled:
      logMessage = NSLocalizedString("LOGGER_VIEW_MAIL_CANCELLED_ALERT_MSG", comment: "")
      
    case .failed:
      logMessage = NSLocalizedString("LOGGER_VIEW_MAIL_FAILED_ALERT_MSG", comment: "")
      
    case .saved:
      logMessage = NSLocalizedString("LOGGER_VIEW_MAIL_SAVED_ALERT_MSG", comment: "")
      
    case .sent:
      logMessage = NSLocalizedString("LOGGER_VIEW_MAIL_SENT_ALERT_MSG", comment: "")
    }
    
    Logger.logInfo(message: logMessage)
    
    controller.dismiss(animated: true, completion: nil)
  }
}


// MARK: - Present/Dismiss
extension LoggerView {
  
  static func present() {
    guard let window = UIApplication.shared.keyWindow else { return }
    let xStartAnimationPos = CGFloat(0)
    let yStartAnimationPos = viewHeight
    let xEndAnimationPos = CGFloat(0)
    let yEndAnimationPos = statusBarHeight
    
    shared.frame = CGRect(x: xStartAnimationPos, y: yStartAnimationPos, width: viewWidth, height: viewHeight)
    UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseIn, animations: {
      shared.frame = CGRect(x: xEndAnimationPos, y: yEndAnimationPos, width: viewWidth, height: viewHeight)
    })
    
    window.addSubview(shared)
  }
  
  
  static func dismiss() {
    let xEndAnimationPos = CGFloat(0)
    let yEndAnimationPos = viewHeight
    
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
      shared.frame = CGRect(x: xEndAnimationPos, y: yEndAnimationPos, width: viewWidth, height: viewHeight)
    }, completion: { finished in
      guard finished else { return }
      shared.removeFromSuperview()
    })
  }
  
  
  static private var viewHeight: CGFloat {
    guard let window = UIApplication.shared.keyWindow else { return 0 }
    return window.bounds.size.height - statusBarHeight
  }
  
  static private var viewWidth: CGFloat {
    guard let window = UIApplication.shared.keyWindow else { return 0 }
    return window.bounds.size.width
  }
  
  static private var statusBarHeight: CGFloat {
    let view = UIView(frame: UIApplication.shared.statusBarFrame)
    return view.frame.size.height
  }
  
}
