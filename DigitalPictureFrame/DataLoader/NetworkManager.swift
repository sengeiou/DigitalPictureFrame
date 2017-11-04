//
//  NetworkManager.swift
//  TableViewWithMultipleCellTypes
//
//  Created by Pawel Milek on 10/19/17.
//  Copyright © 2017 Pawel Milek. All rights reserved.
//

import Foundation
import Firebase

final class NetworkManager {
  static let shared = NetworkManager()
  
  private let ref: DatabaseReference
  
  private init() {
    ref = Database.database().reference()
  }
}


// MARK: - Fetch data
extension NetworkManager {
  
  func fetchData(completionHandler: @escaping (NetworkResultType<DigitalPictureFrameData, NetworkError>)->()) {
    ref.observe(.value, with: { snapshot in
      if let snapshotDict = snapshot.value as? [String: Any],
         let jsonData = try? JSONSerialization.data(withJSONObject: snapshotDict, options: []) {
        if let digitalFrameData = try? JSONDecoder().decode(DigitalPictureFrameData.self, from: jsonData) {
          completionHandler(.success(digitalFrameData))
        } else {
          completionHandler(.failure(NetworkError.dataNotAvailable))
        }
      } else {
        completionHandler(.failure(NetworkError.dataNotAvailable))
      }
    })
  }
  
}
