//
//  MemoTextViewTableViewCell.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/15/24.
//

import UIKit
import SnapKit
import Then

class MemoTextViewTableViewCell: BaseTableViewCell {
  
  var delegate: TableViewCellDeleagte?
  
  lazy var textView: UITextView = .init().then {
    $0.textColor = UIColor.lightGray
    $0.textAlignment = .left
    $0.delegate = self
    $0.isScrollEnabled = true
    $0.sizeToFit()
    $0.text = "메시지를 입력하세요"
  }
  
  override func configView() {
    backgroundColor = .white
  }
  
  override func configLayout() {
    
    textView.snp.makeConstraints {
      $0.edges.equalTo(safeAreaLayoutGuide)
    }
  }
  
  override func configHierarchy() {
    addSubviews([textView])
  }
}

extension MemoTextViewTableViewCell: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
      textView.textColor = UIColor.black
    }
    
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "메세지를 입력하세요"
      textView.textColor = UIColor.lightGray
    }
  }
  
  func textViewDidChange(_ textView: UITextView) {
    delegate?.updateTextViewHeight(self, textView)
  }
}

protocol TableViewCellDeleagte: AnyObject {
  func updateTextViewHeight(_ cell: UITableViewCell, _ textView: UITextView) -> Void
}

@available(iOS 17.0, *)
#Preview {
  MemoTextViewTableViewCell()
}
