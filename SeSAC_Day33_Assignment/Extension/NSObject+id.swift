//
//  NSObject+id.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import Foundation

extension NSObject {
  static var identifier: String {
    String(describing: self)
  }
}
