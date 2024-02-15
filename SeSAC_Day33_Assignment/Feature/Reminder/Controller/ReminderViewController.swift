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

// MARK: 
extension ReminderViewController {
  
}

extension ReminderViewController {
  
  func configToolBar(){
    // 기본적으로 숨겨져 있으므로 보이도록 설정
    navigationController?.isToolbarHidden = false
    
    let leftItem = UIButton().then {
      $0.setTitle("새로운 미리 알림", for: .normal)
      $0.setTitleColor(UIColor.systemBlue, for: .normal)
      $0.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
      $0.addTarget(self, action: #selector(tappedAddNewTodoButton), for: .touchUpInside)
    }
    
    let rightItem = UIBarButtonItem(
      title: "목록추가",
      style: .plain,
      target: self,
      action: #selector(tappedAddNewListButton)
    )
    
    toolbarItems = [UIBarButtonItem(customView: leftItem),.flexibleSpace(),rightItem]
  }
  
  func configNavigationBar(){
//    navigationItem.title = "전체"
//    navigationController?.navigationBar.prefersLargeTitles = true
    // 후속 뷰에서는 적용안되도록 설정
    navigationItem.largeTitleDisplayMode = .always
    
    let rightItem = UIButton().then {
      $0.setImage(UIImage(systemName: "ellipsis.circle.fill"), for: .normal)
      let edit = UIAction(title: "목록 편집", image: UIImage(systemName: "square.on.square"), handler: { _ in })
      let template = UIAction(title: "템플릿", image: UIImage(systemName: "pencil"), handler: { _ in })
      let buttonMenu = UIMenu(title: "", children: [edit, template])
      $0.menu = buttonMenu
      $0.showsMenuAsPrimaryAction = true
    }
    
    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(customView: rightItem)
    ]
  }
}

extension ReminderViewController {

  @objc func tappedAddNewTodoButton() { sheetNewTodo() }
  
  @objc func tappedAddNewListButton() {}
  
  @objc func tappedMoreButton() {}
  
  @objc func tappedEditButton() {}
  
  @objc func tappedTemplateButton() {}
  
  @objc func sheetNewTodo(){
    let vc = NewTodoViewController().wrapToNavigationVC()
    present(vc, animated: true)
  }
}

@available(iOS 17.0, *)
#Preview {
  ReminderViewController().wrapToNavigationVC()
}
