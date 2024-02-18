//
//  BaseView.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import UIKit

class BaseView: UIView, BaseViewConfigurable {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configBase()
    self.backgroundColor = .white
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.configBase()
  }
  
  func configView() {}
  func configLayout() {}
  func configHierarchy() {}
}
