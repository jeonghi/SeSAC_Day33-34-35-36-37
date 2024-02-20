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
  
  var defaultPredicate: NSPredicate? {
    didSet {
      self.filterTodoItems(by: defaultPredicate)
    }
  }
  
  var todoItems: Results<TodoItem>? {
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
    filterTodoItems(by: defaultPredicate)
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
    let rightItem = UIButton().then {
      $0.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
      
      let buttonActions: [UIAction] = SortOption.allCases.map { option in
        UIAction(title: option.rawValue, handler: { _ in self.tappedSortButton(option)})
      }
      
      let buttonMenu = UIMenu(title: "", children: buttonActions)
      $0.menu = buttonMenu
      $0.showsMenuAsPrimaryAction = true
    }
    
    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(customView: rightItem)
    ]
  }
  
  
  func tappedSortButton(_ sortOption: SortOption) {
    let ascending: Bool
    switch sortOption {
      // 오름차순
    case .createDate, .title, .dueDate:
      ascending = true
      
      // 내림차순
    case .priority:
      ascending = false
    }
    
    sortTodoItems(by: sortOption, ascending: ascending)
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
    todoItems?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoItemListTableViewCell.identifier, for: indexPath) as? TodoItemListTableViewCell else {
      return .init()
    }
    
    let model = todoItems?[indexPath.row]
    
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
  
  enum SortOption: String, CaseIterable {
    case createDate = "생성날짜"
    case dueDate = "마감일"
    case priority = "우선순위"
    case title = "제목"
  }
  
  func sortTodoItems(by option: SortOption, ascending: Bool) {
    switch option {
    case .createDate:
      todoItems = todoItems?.sorted(byKeyPath: "createdAt", ascending: ascending)
    case .dueDate:
      todoItems = todoItems?.sorted(byKeyPath: "dueDate", ascending: ascending)
    case .priority:
      todoItems = todoItems?.sorted(byKeyPath: "priority", ascending: ascending)
    case .title:
      todoItems = todoItems?.sorted(byKeyPath: "title", ascending: ascending)
    }
  }
  func filterTodoItems(by option: NSPredicate?) {
    todoItems = todoRepository.readFiltered(by: option ?? NSPredicate(value: true))
  }
}

extension TodoItemListViewController {
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    nil
  }
  
  @available(iOS, introduced: 11.0)
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    
    guard let todoItem = self.todoItems?[indexPath.item] else {
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
