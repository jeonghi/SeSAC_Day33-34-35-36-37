//
//  UITextField+Extension.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/15/24.
//

import UIKit

extension UITextField {
  func addBottomLineToTextField() {
    let bottomLine = CALayer()
    bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
    bottomLine.backgroundColor = UIColor.lightGray.cgColor
    self.borderStyle = .none // 기본 border 제거
    self.layer.addSublayer(bottomLine)
  }
}
