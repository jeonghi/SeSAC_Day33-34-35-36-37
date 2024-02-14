//
//  Priority.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import Foundation

enum Priority: Int, CaseIterable {
  case one = 1
  case two
  case three
  case four
  case five
  case six
  case seven
  
  var stringValue: String {
    return "\(self.rawValue)"
  }
}
