//
//  TodoItemListTableViewCell.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/19/24.
//

import UIKit
import SnapKit
import Then

class TodoItemListTableViewCell: BaseTableViewCell {
  
  let doneButton = UIButton()
  let priorityLabel = UILabel().then {
    $0.textColor = .link
    $0.textAlignment = .left
  }
  let titleLabel = UILabel().then{
    $0.numberOfLines = 1
    $0.textAlignment = .left
  }
  let memoLabel = UILabel().then{
    $0.numberOfLines = 1
    $0.textAlignment = .left
    $0.textColor = .darkGray
  }
  let dateLabel = UILabel()
  let tagLabel = UILabel().then {
    $0.numberOfLines = 1
    $0.textAlignment = .left
    $0.textColor = .link
  }
  
  lazy var titleStackView = UIStackView(arrangedSubviews: [priorityLabel, titleLabel]).then {
    $0.axis = .horizontal
    $0.alignment = .leading
    $0.distribution = .fill
    $0.spacing = 2
  }
  lazy var optionStackView = UIStackView(arrangedSubviews: [dateLabel, tagLabel]).then {
    $0.axis = .horizontal
    $0.alignment = .leading
    $0.distribution = .fill
    $0.spacing = 10
  }
  lazy var mainStackView = UIStackView(arrangedSubviews: [titleStackView, memoLabel, optionStackView]).then {
    $0.axis = .vertical
    $0.alignment = .fill
    $0.distribution = .fill
    $0.spacing = 5
  }
  
  override func configView() {
    config()
  }
  
  override func configLayout() {
    doneButton.snp.makeConstraints {
      $0.size.equalTo(45)
      $0.top.left.equalToSuperview().offset(10)
    }
    mainStackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10) // 상단 여백
      $0.left.equalTo(doneButton.snp.right).offset(10) // doneButton 옆에 배치
      $0.right.equalToSuperview().inset(10) // 우측 여백
      $0.bottom.equalToSuperview().offset(-10) // 하단 여백 추가
    }
    
    priorityLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

    dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    tagLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
  }
  
  override func configHierarchy() {
    addSubviews([doneButton, mainStackView])
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    config()
  }
  
  func config(title: String? = nil, memo: String? = nil, dueDate: Date? = nil, priority: Priority? = nil, tag: String? = nil, isDone: Bool = false) {
    titleLabel.text = title
    memoLabel.text = memo
    dateLabel.do {
      if let dueDate {
        $0.isHidden = false
        $0.text = dueDate.toString()
      } else {
        $0.isHidden = true
      }
    }
    priorityLabel.do {
      if let priority {
        $0.isHidden = false
        $0.text = String(repeating: "!", count: Priority.allCases.count - priority.rawValue)
      } else {
        $0.isHidden = true
      }
    }
    tagLabel.do {
      if let tag {
        $0.isHidden = false
        $0.text = "#\(tag)"
      } else {
        $0.isHidden = true
      }
    }
    doneButton.do {
      $0.setImage(UIImage(systemName: isDone ? "circle.fill" : "circle")?.withTintColor(UIColor.lightGray, renderingMode: .alwaysOriginal), for: .normal)
    }
  }
}
