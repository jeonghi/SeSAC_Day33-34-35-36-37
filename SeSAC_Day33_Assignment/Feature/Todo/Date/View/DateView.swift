//
//  DateView.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import UIKit
import Then
import SnapKit

class DateView: BaseView {
  
  let datePicker = UIDatePicker().then {
    $0.preferredDatePickerStyle = .inline
    $0.datePickerMode = .date
    $0.locale = Locale(identifier: "ko-KR")
    $0.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
  }
  
  override func configView() {
    backgroundColor = .white
  }
  
  override func configLayout() {
    datePicker.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide).offset(20)
      $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
    }
  }
  
  override func configHierarchy() {
    addSubviews([datePicker])
  }
  
  @objc func dateChanged(_ sender: UIDatePicker) {
    NotificationCenter.default.post(name: Notification.Name("SelectedDateChanged"), object: sender.date)
  }
}

@available(iOS 17.0, *)
#Preview {
  DateView()
}
