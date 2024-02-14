//
//  PriorityView.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import UIKit
import Then
import SnapKit

class PriorityView: BaseView {
  
  var selectedPriority: Priority = .one {
    didSet {
      print("Selected Priority: \(selectedPriority.rawValue)")
      NotificationCenter.default.post(name: Notification.Name("SelectedPriorityChanged"), object: selectedPriority)
    }
  }
  
  let segmentControl = UISegmentedControl(items: Priority.allCases.map { $0.stringValue }).then {
    $0.selectedSegmentIndex = 0
    $0.backgroundColor = .lightGray
    $0.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
  }
  
  override func configView() {
    backgroundColor = .white
  }
  
  override func configHierarchy() {
    addSubviews([segmentControl])
  }
  
  override func configLayout() {
    segmentControl.snp.makeConstraints {
      $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
      $0.top.equalTo(safeAreaLayoutGuide).offset(20)
    }
  }
  
  @objc func segmentValueChanged(_ sender: UISegmentedControl) {
    guard let selectedPriorityIndex = Priority(rawValue: sender.selectedSegmentIndex + 1) else { return }
    selectedPriority = selectedPriorityIndex
  }
}
@available(iOS 17.0, *)
#Preview {
  PriorityView()
}
