//
//  UISearchBar+Extension.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/17/24.
//

import UIKit

extension UISearchBar {
  func enable() {
    isUserInteractionEnabled = true
    alpha = 1.0
  }
  
  func disable() {
    isUserInteractionEnabled = false
    alpha = 0.5
  }
}
