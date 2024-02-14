//
//  UIView+addSubviews.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import UIKit

extension UIView {
  func addSubviews(_ views: [UIView]) {
    views.forEach {
      self.addSubview($0)
    }
  }
}
