//
//  TagView.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import UIKit
import Then
import SnapKit

class TagView: BaseView {
  
  
  var action: ((String?) -> Void)? = nil
  
  let textField = UITextField().then {
    $0.borderStyle = .roundedRect
    $0.backgroundColor = .lightGray.withAlphaComponent(0.2)
    $0.placeholder = "태그를 입력하세요"
    $0.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
  }
  
  override func configView() {
    backgroundColor = .white
  }
  
  override func configHierarchy() {
    addSubviews([textField])
  }
  
  override func configLayout() {
    textField.snp.makeConstraints {
      $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
      $0.top.equalTo(safeAreaLayoutGuide).offset(20)
    }
  }
  
  @objc func textFieldChanged(_ sender: UITextField) {
    action?(sender.text)
  }
}


@available(iOS 17.0, *)
#Preview {
  TagView()
}
