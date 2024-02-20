//
//  TodoDocumentFormViewController.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/21/24.
//

import UIKit
import SnapKit
import Then

class TodoDocumentFormViewController: BaseViewController {
  
  var closeAction: (() -> Void)? = nil
  
  lazy var textField = UITextField().then {
    $0.placeholder = "목록 이름"
    $0.textAlignment = .center
    $0.borderStyle = .roundedRect
    $0.delegate = self
    $0.backgroundColor = .lightGray.withAlphaComponent(0.3)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    textField.becomeFirstResponder()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    textField.resignFirstResponder()
  }
  
  override func configView() {
    configNavigationBar()
  }
  
  func configNavigationBar() {
    let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: nil)
    let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: nil)
    
    navigationItem.rightBarButtonItems = [doneButton]
    navigationItem.leftBarButtonItems = [cancelButton]
  }
  
  override func configHierarchy() {
    view.addSubviews([textField])
  }
  
  override func configLayout() {
    textField.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.centerX.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.9)
      $0.height.equalTo(50)
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    guard let touch = touches.first else { return }
    let touchLocation = touch.location(in: self.view)
    if !textField.frame.contains(touchLocation) {
      textField.resignFirstResponder()
    }
  }
}

extension TodoDocumentFormViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    textField.resignFirstResponder()
  }
}

@available(iOS 17.0, *)
#Preview {
  TodoDocumentFormViewController().wrapToNavigationVC()
}
