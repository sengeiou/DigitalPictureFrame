//
//  PopupCentralManagerStateView.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Reply Inc. All rights reserved.
//

import UIKit


class PopupCentralManagerStateView: UIView, ViewSetupable {
  typealias PopupStateStyle = Style.PopupCentralManagerStateView
  
  private static var messagelabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.font = PopupStateStyle.messageLabelFont
    label.textColor = PopupStateStyle.messageLabelTextColor
    label.textAlignment = PopupStateStyle.messageLabelTextAlignment
    label.numberOfLines = PopupStateStyle.messageLabelNumberOfLines
    
    return label
  }()
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
    setupStyle()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
    setupStyle()
  }
}


// MARK: - ViewSetupable protocol
extension PopupCentralManagerStateView {
  
  func setup() {
    addMessageLabelConstraints()
  }
  
  func setupStyle() {
    backgroundColor = PopupStateStyle.backgroundColor
  }
  
}


// MARK: - Add Message Label Constraints
private extension PopupCentralManagerStateView {
  
  func addMessageLabelConstraints() {
    addSubview(PopupCentralManagerStateView.messagelabel)
    addConstraintsWith(format: "H:|[view0]|", forView: PopupCentralManagerStateView.messagelabel)
    addConstraintsWith(format: "V:|[view0]|", forView: PopupCentralManagerStateView.messagelabel)
  }
  
}


// MARK: - Show/Hide Global Validation Error
extension PopupCentralManagerStateView {
  
  static func showHidePopup(on view: UIView, with message: String) {
    let popupParentViewSize = view.bounds.size
    let viewHeight = CGFloat(45)
    let frame = CGRect(x: 0, y: popupParentViewSize.height, width: popupParentViewSize.width, height: popupParentViewSize.height)
    let popupView = PopupCentralManagerStateView(frame: frame)
    PopupCentralManagerStateView.messagelabel.text = message
    
    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
      popupView.frame = CGRect(x: 0, y: popupParentViewSize.height - viewHeight, width: popupParentViewSize.width, height: viewHeight)
    }, completion: { finished in
      if finished {
        UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseIn, animations: {
          popupView.frame = CGRect(x: 0, y: popupParentViewSize.height, width: popupParentViewSize.width, height: viewHeight)
        }, completion: { finished in
          popupView.removeFromSuperview()
        })
      }
    })
    
    view.addSubview(popupView)
  }
  
}
