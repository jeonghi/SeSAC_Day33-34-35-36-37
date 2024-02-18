//
//  TextInputTableViewCell.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/18/24.
//

import UIKit
import SnapKit

final class TextInputTableViewCell: BaseTableViewCell {
  
  lazy private var editableTextField: UITextField = {
    let textField = UITextField(frame: .zero)
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.addTarget(self, action: #selector(TextInputTableViewCell.textDidChange), for: .editingChanged)
    return textField
  }()
  
  // MARK: Initializing a Cell
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  override func configHierarchy() {
    addSubview(editableTextField)
  }
  
  override func configLayout() {
    editableTextField.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.trailing.equalTo(layoutMarginsGuide)
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
  
  func configure(for model: TextInputFormItem) {
    editableTextField.text = model.text
    editableTextField.placeholder = model.placeholder
    changeHandler = model.didChange
  }
  
  // MARK: Handling Text Input
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    editableTextField.becomeFirstResponder()
  }
  
  private var changeHandler: (String) -> () = { _ in }
  
  @objc private func textDidChange() {
    changeHandler(editableTextField.text ?? "")
  }
}
