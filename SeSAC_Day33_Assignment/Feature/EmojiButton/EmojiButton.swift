//
//  EmojiButton.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/18/24.
//

import UIKit
import Then
import SnapKit

class EmojiButton: UIButton, UIKeyInput {
  var hasText: Bool = true
  override var textInputContextIdentifier: String? { "" } // emoji 키보드를 보여주기 위해 non-nil return
  func insertText(_ text: String) { print("\(text)") }
  func deleteBackward() {}
  override var canBecomeFirstResponder: Bool { return true }
  override var canResignFirstResponder: Bool { return true }
  override var textInputMode: UITextInputMode? {
    for mode in UITextInputMode.activeInputModes {
      if mode.primaryLanguage == "emoji" {
        return mode
      }
    }
    return nil
  }
}

class TestEmojiButtonVC: BaseViewController {
  let emojiButton: EmojiButton = .init().then {
    $0.setTitle("이모지", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = .black
  }
  
  override func configLayout() {
    emojiButton.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.size.equalTo(60)
    }
  }
  
  override func configHierarchy() {
    view.addSubview(emojiButton)
  }
}


#Preview {
  TestEmojiButtonVC()
}
