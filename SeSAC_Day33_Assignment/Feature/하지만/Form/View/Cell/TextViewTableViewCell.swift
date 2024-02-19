//
//  TextViewTableViewCell.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/18/24.
//

import UIKit
import SnapKit
import Then

final class TextViewTableViewCell: BaseTableViewCell {
  
  lazy var editableTextView = PlaceholderTextView().then {
    $0.textAlignment = .left
    $0.delegate = self
    $0.isScrollEnabled = false
    $0.isUserInteractionEnabled = false // 터치 가능하게끔
    $0.sizeToFit()
  }
  
  // MARK: Initializing a Cell
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  override func configHierarchy() {
    addSubview(editableTextView)
  }
  
  override func configLayout() {
    editableTextView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.trailing.equalTo(layoutMarginsGuide)
      $0.height.greaterThanOrEqualTo(80)
    }
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Reusing Cells
  
  override func prepareForReuse() {
    super.prepareForReuse()
    changeHandler = { _ in }
  }
  
  // MARK: Managing the Content
  
  func configure(for model: TextViewFormItem) {
    editableTextView.text = model.text
    editableTextView.placeholderText = model.placeholder
    changeHandler = model.didChange
  }
  
  // MARK: Handling Text Input
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    editableTextView.becomeFirstResponder()
  }
  
  private var changeHandler: (String) -> () = { _ in }
  
  @objc private func textDidChange() {
    changeHandler(editableTextView.text ?? "")
  }
}

extension TextViewTableViewCell: UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
  }
  func textViewDidEndEditing(_ textView: UITextView) {
  }
  
  func textViewDidChange(_ textView: UITextView) {
      guard let tableView = tableView else { return }

      let contentSize = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: .infinity))

      if textView.bounds.height != contentSize.height {
          tableView.contentOffset.y += contentSize.height - textView.bounds.height

          UIView.setAnimationsEnabled(false)
          tableView.beginUpdates()
          tableView.endUpdates()
          UIView.setAnimationsEnabled(true)
      }
  }
}
