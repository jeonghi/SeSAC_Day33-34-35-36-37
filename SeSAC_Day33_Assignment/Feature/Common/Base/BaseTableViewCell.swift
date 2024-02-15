//
//  BaseTableViewCell.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/15/24.
//

import UIKit

class BaseTableViewCell: UITableViewCell, BaseViewConfigurable {
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.prepare()
    self.configBase()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.prepare()
    self.configBase()
  }
  
  func prepare() {}
  
  func configView() {}
  
  func configLayout() {}
  
  func configHierarchy() {}
}
