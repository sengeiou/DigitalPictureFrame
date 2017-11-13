//
//  PickerViewPresentable.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import UIKit

protocol PickerViewPresentable: class {
  weak var presenterViewController: UIViewController? { get set }
  weak var fadeView: UIView? { get set }
}


// MARK: - Size
extension PickerViewPresentable {
  
  var viewHeight: CGFloat {
    return presenterViewController?.view.frame.height ?? 0
  }

  var viewWidth: CGFloat {
    return presenterViewController?.view.frame.width ?? 0
  }
}


// MARK: - Present and dismiss view
extension PickerViewPresentable where Self: UIView {

  func present() {
    guard let fadeView = fadeView else { return }
    let pickerYPos = viewHeight - frame.height
    UIApplication.shared.keyWindow!.addSubview(fadeView)
    fadeView.backgroundColor = UIColor.black.withAlphaComponent(0)
    
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
      self.frame = CGRect(x: 0, y: pickerYPos, width: self.viewWidth, height: self.frame.height)
      fadeView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    })
    
    fadeView.addSubview(self)
  }
  
  func dismiss() {
    fadeView?.backgroundColor = UIColor.black.withAlphaComponent(0)
    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
      self.frame = CGRect(x: 0, y: self.viewHeight, width: self.viewWidth, height: self.frame.height)
    }, completion: { finished in
      self.removeFromSuperview()
      self.fadeView?.removeFromSuperview()
    })
  }

}

