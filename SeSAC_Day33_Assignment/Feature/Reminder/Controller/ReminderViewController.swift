//
//  ReminderViewController.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import UIKit
import Then
import RealmSwift

final class ReminderViewController: BaseViewController {
  
  lazy var remiderView = RemiderView().then {
    $0.tableView.do {
      $0.dataSource = self
      $0.delegate = self
      $0.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
    }
  }
  
  var list: Results<TodoEntity>! {
    didSet {
      remiderView.tableView.reloadData()
    }
  }
  
  override func loadView() {
    view = remiderView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadData()
  }
  
  override func configView() {
    configToolBar()
    configNavigationBar()
  }
}

// MARK:
extension ReminderViewController {
  func loadData() {
    let realm = try! Realm()
    
    // realm 데이터 모두 가져오기
    let data = realm.objects(TodoEntity.self)
      .sorted(byKeyPath: "createdAt", ascending: true)
    
    list = data
  }
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
    navigationItem.title = "전체"
    navigationController?.navigationBar.prefersLargeTitles = true
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
    let vc = NewTodoViewController().then {
      $0.closeAction = {
        self.loadData()
      }
    }
    present(vc.wrapToNavigationVC(), animated: true)
  }
}

extension ReminderViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    list.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .value2, reuseIdentifier: UITableViewCell.identifier)
    let data = list[indexPath.row]
    cell.textLabel?.text = data.title
    cell.detailTextLabel?.text = data.createdAt.formatted()
    return cell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    100
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

@available(iOS 17.0, *)
#Preview {
  ReminderViewController().wrapToNavigationVC()
}
