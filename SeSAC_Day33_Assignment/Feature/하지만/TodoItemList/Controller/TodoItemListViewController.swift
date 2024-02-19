//
//  TodoItemListViewController.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/19/24.
//

import UIKit
import Then
import SnapKit
import RealmSwift

final class TodoItemListViewController: BaseViewController {
  
  var todoRepository: TodoRepository = TodoRepositoryImpl()
  
  var list: Results<TodoItem>? {
    didSet {
      refresh()
    }
  }
  
  lazy var tableView = UITableView().then {
    $0.dataSource = self
    $0.delegate = self
    $0.register(TodoItemListTableViewCell.self, forCellReuseIdentifier: TodoItemListTableViewCell.identifier)
    $0.estimatedRowHeight = 500
    $0.rowHeight = UITableView.automaticDimension
  }
  
  override func loadView() {
    super.loadView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    list = todoRepository.readAll()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  
  override func configView() {
    configNavigationBar()
  }
  
  override func configHierarchy() {
    view.addSubview(tableView)
  }
  
  override func configLayout() {
    
  }
  
  func configNavigationBar() {
    
  }
  
  func sheetEditTodo(_ todoItem: TodoItem) {
    let vc = FormViewController(todo: todoItem).then {
      $0.closeAction = {}
    }
    vc.navigationItem.title = "할 일 수정하기"
    self.present(vc.wrapToNavigationVC(), animated: true, completion: {})
  }
  
  func refresh() {
    tableView.reloadData()
  }
}

extension TodoItemListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    list?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoItemListTableViewCell.identifier, for: indexPath) as? TodoItemListTableViewCell else {
      return .init()
    }
    
    let model = list?[indexPath.row]
    
    cell.config(title: model?.title, memo: model?.memo, dueDate: model?.dueDate, priority: model?.priority, tag: model?.tag, isDone: true)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }
}

extension TodoItemListViewController {
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    nil
  }
  
  @available(iOS, introduced: 11.0)
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    
    guard let todoItem = self.list?[indexPath.item] else {
      return nil
    }
    
    // 수정하기
    let editAction = UIContextualAction(style: .normal, title: "수정") {
      action, view, completion in
      self.sheetEditTodo(todoItem)
      completion(true)
    }
    
    editAction.image = UIImage(systemName: "pencil")
    editAction.backgroundColor = .link
    
    // 지우기
    let trashAction = UIContextualAction(style: .normal, title: "삭제") { action, view, completion in
      
      self.todoRepository.delete(todoItem: todoItem)
      self.tableView.deleteRows(at: [indexPath], with: .fade)
      completion(true)
    }
    
    trashAction.image = UIImage(systemName: "trash.fill")
    trashAction.backgroundColor = .red
    
    let configuration = UISwipeActionsConfiguration(actions: [trashAction, editAction])
    return configuration
  }
}

@available(iOS 17.0, *)
#Preview {
  TodoItemListViewController().wrapToNavigationVC()
}
