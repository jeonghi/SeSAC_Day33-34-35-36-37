//
//  Priority.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import RealmSwift

enum Priority: Int, CaseIterable {
  case high = 0 // 상
  case medium = 1 // 중
  case low = 2 // 하
  
  var description: String {
    switch self {
    case .high: return "상"
    case .medium: return "중"
    case .low: return "하"
    }
  }
}
extension Priority: PersistableEnum {}
