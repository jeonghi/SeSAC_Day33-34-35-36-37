//
//  ReminderViewController.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import UIKit
import Then

final class ReminderViewController: BaseViewController {
  
  let remiderView = RemiderView()
  
  override func loadView() {
    view = remiderView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func configView() {
    configToolBar()
    configNavigationBar()
  }
}

extension ReminderViewController {
  func configToolBar(){
    // 기본적으로 숨겨져 있으므로 보이도록 설정
    navigationController?.isToolbarHidden = false
    
    let leftItem = UIBarButtonItem(
      title: "새로운 할 일",
      image: UIImage(systemName: "plus.circle.fill"),
      target: self,
      action: #selector(tappedAddNewTodo)
    )
    
    let rightItem = UIBarButtonItem(
      title: "목록추가",
      style: .plain,
      target: self,
      action: #selector(tappedAddNewList)
    )
    
    toolbarItems = [leftItem,.flexibleSpace(),rightItem]
  }
  
  @objc
  func tappedAddNewTodo(){
    let vc = NewTodoViewController().wrapToNavigationVC()
    present(vc, animated: true)
  }
  
  @objc
  func tappedAddNewList(){
    
  }
  
  @objc
  func sheetNewTodo(){
  }
  
  func configNavigationBar(){
    navigationItem.title = "전체"
    navigationController?.navigationBar.prefersLargeTitles = true
    // 후속 뷰에서는 적용안되도록 설정
    navigationItem.largeTitleDisplayMode = .always
  }
}

@available(iOS 17.0, *)
#Preview {
  ReminderViewController().wrapToNavigationVC()
}
