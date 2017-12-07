//
//  AccessVerifier.swift
//  DigitalPictureFrame
//
//  Created by Pawel Milek.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation

struct AccessVerifier {
  private let userDefaults = UserDefaults.standard
  private let hasVerifiedKey = PhoneNumberVerificationKey.hasVerified.rawValue
  private let hasEnteredKey = PhoneNumberVerificationKey.hasEntered.rawValue
  private let retrivedPhoneNumber: String?
  
  
  init(data: DigitalPictureFrameData?) {
    self.retrivedPhoneNumber = data?.phoneNumber
  }
  
}


// MARK: - Verify
extension AccessVerifier {
  
  func verify(enteredPhoneNumber: String) throws {
    guard let retrivedPhoneNumber = retrivedPhoneNumber else {
      storeAccessDenied()
      throw AccessVerifierError.dataNotAvailable(description: "Retrived Phone Number")
    }
    
    guard !enteredPhoneNumber.isEmpty else {
      storeAccessDenied()
      throw AccessVerifierError.dataNotAvailable(description: "Entered Phone Number")
    }
    
    if retrivedPhoneNumber.isEqual(to: enteredPhoneNumber) {
      storeAccessGranted(for: enteredPhoneNumber)
    } else {
      storeAccessDenied()
      throw AccessVerifierError.accessDenied
    }
  }
  
}


// MARK: - Store user defaults
private extension AccessVerifier {
  
  func storeAccessGranted(for phoneNumber: String) {
    userDefaults.set(true, forKey: hasVerifiedKey)
    userDefaults.set(phoneNumber, forKey: hasEnteredKey)
  }
  
  
  func storeAccessDenied() {
    userDefaults.set(false, forKey: hasVerifiedKey)
    userDefaults.set("", forKey: hasEnteredKey)
  }
  
}


// MARK: - Retrieve user defaults
extension AccessVerifier {
  
  var isAccessGranted: Bool {
    guard let retrivedPhoneNumber = retrivedPhoneNumber else { return false }
    guard let enteredPhoneNumber = userDefaults.string(forKey: hasEnteredKey) else { return false }
    return retrivedPhoneNumber.isEqual(to: enteredPhoneNumber) && userDefaults.bool(forKey: hasVerifiedKey)
  }
  
}
