//
//  MemoTableViewCell.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/15/24.
//

import UIKit
import SnapKit
import Then

class TitleTextFieldTableViewCell: BaseTableViewCell {
  
  let textField: UITextField = .init().then {
    $0.placeholder = "제목"
    $0.textAlignment = .left
  }
  
  override func configView() {
    backgroundColor = .white
  }
  
  override func configLayout() {
    textField.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview()
      $0.centerY.equalToSuperview()
    }
  }
  
  override func configHierarchy() {
    addSubviews([textField])
  }
}

@available(iOS 17.0, *)
#Preview {
  TitleTextFieldTableViewCell()
}
