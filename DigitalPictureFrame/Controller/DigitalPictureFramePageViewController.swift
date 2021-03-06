//
//  DigitalPictureFramePageViewController.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DigitalPictureFramePageViewController: UIPageViewController {
  private let userDefaults = UserDefaults.standard
  private var data: DigitalPictureFrameData?
  
  private var activityData: ActivityData {
    return ActivityData(size: CGSize(width: 40, height: 40), type: .ballSpinFadeLoader, color: UIColor.appleBlue)
  }
  
  lazy private var orderedViewControllers: [UIViewController] = {
    let mainStoryboard = UIStoryboard(storyboard: .main)
    let usersVC = mainStoryboard.instantiateViewController(UserViewController.self)
    let settingsVC = mainStoryboard.instantiateViewController(SettingsViewController.self)
    let wifiVC = mainStoryboard.instantiateViewController(WiFiViewController.self)
    
    let bluetoothStoryboard = UIStoryboard(storyboard: .bluetooth)
    let bluetoothVC = bluetoothStoryboard.instantiateViewController(BluetoothConnectivityViewController.self)
    return [usersVC, settingsVC, wifiVC, bluetoothVC]
  }()
  
  private var currentPageIndex: Int? {
    get {
      guard let visibleVC = viewControllers?.first else { return nil }
      return orderedViewControllers.index(of: visibleVC)
    }
    
    set {
      guard let currentPageIndex = currentPageIndex,
            let newValue = newValue, newValue >= 0, newValue < orderedViewControllers.count else { return }
      let vc = orderedViewControllers[newValue]
      let direction: UIPageViewControllerNavigationDirection = (newValue > currentPageIndex ? .forward : .reverse)
      self.setViewControllers([vc], direction: direction, animated: true, completion: nil)
    }
  }

  
  private var isUserPhoneNumberVerified: Bool {
    return AccessVerifier(data: data).isAccessGranted
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  
  deinit {
    unregisterNotification()
  }
}


// MARK: - ViewSetupable protocol
extension DigitalPictureFramePageViewController: ViewSetupable {
  
  func setup() {
    assignDelegate()
    registerNotification()
    loadData()
    initialiseFirstViewController()
  }
}


// MARK: - Assign delegate
private extension DigitalPictureFramePageViewController {
  
  func assignDelegate() {
    dataSource = self
    delegate = self
  }
  
}


// MARK: - Add Notification Observer
extension DigitalPictureFramePageViewController {
  
  func registerNotification() {
    addRefreshDataNofificationObserver()
  }
  
  func unregisterNotification() {
    removeRefreshDataNofificationObserver()
  }
  
  
  func addRefreshDataNofificationObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(DigitalPictureFramePageViewController.refreshData(_:)),
                                           name: NotificationName.refreshData.name, object: nil)
  }
  
  func removeRefreshDataNofificationObserver() {
    NotificationCenter.default.removeObserver(self, name: NotificationName.refreshData.name, object: nil)
  }
  
  
  @objc func refreshData(_ sender: Any) {
    loadData()
  }
  
}


// MARK: - Load data
private extension DigitalPictureFramePageViewController {
  
  func loadData() {
    NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    
    DatabaseManager.shared().retrieve(completionHandler: {[unowned self] result in
      switch result {
      case .success(let data):
        self.data = data
        self.verifyUserCredentials()
        self.sendNotificationToReloadUserData()
        self.sendNotificationToEndRefreshingIndicator()
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        
      case .failure(let error):
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        self.sendNotificationToReloadUserData()
        AlertViewPresenter.sharedInstance.presentErrorAlert(withMessage: error.localizedDescription)
      }
    })
  }
  
  
  func sendNotificationToReloadUserData() {
    NotificationCenter.default.post(name: NotificationName.reloadData.name, object: nil)
  }
  
  func sendNotificationToEndRefreshingIndicator() {
    NotificationCenter.default.post(name: NotificationName.endRefreshingIndicator.name, object: nil)
  }
}


// MARK: Initialise Users ViewController
private extension DigitalPictureFramePageViewController {
  
  func initialiseFirstViewController() {
    guard let usersVC = orderedViewControllers.first as? UserViewController else { return }
    setViewControllers([usersVC], direction: .forward, animated: true)
  }

}


// MARK: - Verify user credential
private extension DigitalPictureFramePageViewController {
  
  func verifyUserCredentials() {
    guard isUserPhoneNumberVerified else {
      DatabaseManager.shared().clearData()
      sendNotificationToReloadUserData()
      
      let title = NSLocalizedString("DIGITAL_PICTURE_FRAME_PAGEVIEW_ALERT_VERIFY_TITLE", comment: "")
      let message = NSLocalizedString("DIGITAL_PICTURE_FRAME_PAGEVIEW_ALERT_VERIFY_MSG", comment: "")
      AlertViewPresenter.sharedInstance.delegate = self
      AlertViewPresenter.sharedInstance.presentSubmitAlert(in: self, title: title, message: message, textFieldConfiguration: { textField in
        textField.placeholder = NSLocalizedString("DIGITAL_PICTURE_FRAME_PAGEVIEW_ALERT_VERIFY_PLACEHOLDER", comment: "")
        textField.keyboardAppearance = .dark
        textField.keyboardType = .phonePad
        textField.clearButtonMode = .whileEditing
      })
      
      return
    }
    
    
    initializeDatabase()
  }
  
  
  func initializeDatabase() {
    let _ = DatabaseManager.shared(data: data)
  }
}


// MARK: - AlertViewPresenterDelegate protocol
extension DigitalPictureFramePageViewController: AlertViewPresenterDelegate {
  
  func alertView(_ alertViewPresenter: AlertViewPresenter, didSubmit result: String) {
    guard !result.isEmpty else { return }
    
    do {
      let verifier = AccessVerifier(data: data)
      try verifier.verify(enteredPhoneNumber: result)
      
      NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
      initializeDatabase()
      sendNotificationToReloadUserData()
      NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
      
    } catch let error as AccessVerifierError {
      AccessVerifierError.handle(error: error)
    } catch {
      AccessVerifierError.handle(error: .unsupportedError)
    }
  }
  
}


// MARK: - UIPageViewControllerDataSource protocol
extension DigitalPictureFramePageViewController: UIPageViewControllerDataSource {
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else { return nil }
    
    let previousIndex = viewControllerIndex - 1
    guard previousIndex >= 0, orderedViewControllers.count > previousIndex else { return nil }
    return orderedViewControllers[previousIndex]
  }
  
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else { return nil }
    
    let nextIndex = viewControllerIndex + 1
    let orderedViewControllersCount = orderedViewControllers.count
    guard orderedViewControllersCount != nextIndex, orderedViewControllersCount > nextIndex else { return nil }
    return orderedViewControllers[nextIndex]
  }
  
}

// MARK: - UIPageViewControllerDelegate protocol
extension DigitalPictureFramePageViewController: UIPageViewControllerDelegate {
  
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    guard let currentPageIndex = currentPageIndex, completed else { return }
    NotificationCenter.default.post(name: NotificationName.tabBarItemSelectedAtIndex.name, object: nil, userInfo: [NotificationUserInfoKey.currentPageIndex.rawValue: currentPageIndex])
  }
  
}


// MARK: - ContainerViewControllerDelegate protocol
extension DigitalPictureFramePageViewController: ContainerViewControllerDelegate {
  
  func containerViewController(_ containerViewController: ContainerViewController, didSelectPageAt index: Int) {
    currentPageIndex = index
  }
  
}
