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
      refresh()
    }
  }
  
  var defaultSortOption: SortOption = .createDate {
    didSet {
      refresh()
    }
  }
  
  var todoItems: Results<TodoItem>?
  
  lazy var tableView = UITableView().then {
    $0.dataSource = self
    $0.delegate = self
    $0.register(TodoItemListTableViewCell.self, forCellReuseIdentifier: TodoItemListTableViewCell.identifier)
    $0.estimatedRowHeight = 500
    $0.rowHeight = UITableView.automaticDimension
  }
  
  // MARK: 뷰컨 라이프 사이클
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    refresh()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
  
  // MARK: 뷰 기본 설정
  override func configView() {
    configNavigationBar()
  }
  
  override func configHierarchy() {
    view.addSubview(tableView)
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
  
  // MARK: Action
  func tappedSortButton(_ sortOption: SortOption) {
    self.defaultSortOption = sortOption
  }
}

// MARK: 테이블 뷰 관련
extension TodoItemListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func refresh() {
    
    // ‼️ 시간나면, 리포지토리에 온전히 분리시키기
    filterTodoItems(by: defaultPredicate)
    sortTodoItems(by: defaultSortOption)
    
    tableView.reloadData()
  }
  
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

// MARK: 데이터 조작 관련 - 정렬, 필터
extension TodoItemListViewController {
  
  // ‼️ 이거 나중에 뷰컨에 분리시키기
  enum SortOption: String, CaseIterable {
    case createDate = "생성날짜"
    case dueDate = "마감일"
    case priority = "우선순위"
    case title = "제목"
    
    var keyPath: String {
        switch self {
        case .createDate:
            return "timestamps.createdAt"
        case .dueDate:
            return "dueDate"
        case .priority:
            return "priority"
        case .title:
            return "title"
        }
    }
    
    var isAscending: Bool {
      switch self {
      case .createDate, .title, .dueDate:
        return true
        
        // 내림차순
      case .priority:
        return false
      }
    }
  }
  
  func sortTodoItems(by option: SortOption) {
    todoItems = todoItems?.sorted(byKeyPath: option.keyPath, ascending: option.isAscending)
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
    
    /// 수정하기 액션
    let editAction = UIContextualAction(style: .normal, title: "수정") {
      action, view, completion in
      let vc = TodoFormViewController(todo: todoItem).then {
        $0.navigationItem.title = "할 일 수정하기"
        $0.closeAction = {
          self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
      }
      self.present(vc.wrapToNavigationVC(), animated: true, completion: {})
      completion(true)
    }.then {
      $0.image = UIImage(systemName: "pencil")
      $0.backgroundColor = .link
    }
    
    /// 지우기 액션
    let trashAction = UIContextualAction(style: .normal, title: "삭제") { action, view, completion in
      self.todoRepository.delete(todoItem: todoItem)
      self.tableView.deleteRows(at: [indexPath], with: .fade)
      completion(true)
    }.then {
      $0.image = UIImage(systemName: "trash.fill")
      $0.backgroundColor = .red
    }
    
    /// 스와이프 액션들 설정하기
    let configuration = UISwipeActionsConfiguration(actions: [trashAction, editAction])
    
    return configuration
  }
}

@available(iOS 17.0, *)
#Preview {
  TodoItemListViewController().wrapToNavigationVC()
}
