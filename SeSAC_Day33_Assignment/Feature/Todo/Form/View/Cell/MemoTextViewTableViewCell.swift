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
  
  lazy var textView: UITextView = .init().then {
    $0.textColor = UIColor.lightGray
    $0.textAlignment = .left
    $0.delegate = self
    $0.isScrollEnabled = true
    $0.sizeToFit()
    $0.text = "메시지를 입력하세요"
    $0.backgroundColor = .white
    $0.isUserInteractionEnabled = false // 터치 가능하게끔
  }
  
  override func configView() {
    
  }
  
  override func configLayout() {
    
    textView.snp.makeConstraints {
      $0.edges.equalTo(contentView)
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

@available(iOS 17.0, *)
#Preview {
  MemoTextViewTableViewCell()
}
