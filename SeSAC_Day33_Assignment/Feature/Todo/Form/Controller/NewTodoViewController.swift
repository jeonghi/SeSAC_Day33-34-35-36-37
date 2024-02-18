//
//  NewTodoViewController.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import UIKit
import RealmSwift
import SnapKit
import Then

class NewTodoViewController: BaseViewController {
  
  lazy var newTodoView = NewTodoView().then {
    $0.tableView.do {
      $0.dataSource = self
      $0.delegate = self
      
      $0.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
      
      $0.register(MemoTextViewTableViewCell.self, forCellReuseIdentifier: MemoTextViewTableViewCell.identifier)
      
      $0.register(TitleTextFieldTableViewCell.self, forCellReuseIdentifier: TitleTextFieldTableViewCell.identifier)
    }
  }
  
  var closeAction: (() -> Void)?
  
  var newTodo: TodoEntity = .init()
  
  let sections: [Section] = Section.allCases
  
  var tasks: Results<TodoEntity>?
  
  override func loadView() {
    view = newTodoView
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    newTodoView.tableView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let realm = try! Realm()
    
    print(realm.configuration.fileURL)
    
    // NotificationCenter 옵저버 등록
    NotificationCenter.default.addObserver(self, selector: #selector(handleSelectedPriorityChanged(_:)), name: Notification.Name("SelectedPriorityChanged"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleSelectedDateChanged(_:)), name: Notification.Name("SelectedDateChanged"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(handleTagTextFieldChanged(_:)), name: Notification.Name("TextFieldChanged"), object: nil)
  }
  
  override func configView() {
    configNavigationBar()
  }
  
  override func configLayout() {
    
    
  }
  override func configHierarchy() {
    
  }
  
  func configNavigationBar() {
    navigationController?.isToolbarHidden = false
    
    let leftItem = UIBarButtonItem(
      title: "취소",
      style: .plain,
      target: self,
      action: #selector(tappedCancelButton)
    )
    
    let rightItem = UIBarButtonItem(
      title: "추가",
      style: .plain,
      target: self,
      action: #selector(tappedAddButton)
    )
    
    navigationItem.leftBarButtonItems = [leftItem]
    navigationItem.rightBarButtonItems = [rightItem]
    
    navigationItem.title = "새로운 미리 알림"
  }
  
  @objc
  func tappedCancelButton() {
    dismiss(animated: true)
  }
  
  @objc
  func tappedAddButton() {
    let realm = try! Realm()
    
    try! realm.write {
      realm.add(self.newTodo)
    }
    
    closeAction?()
    dismiss(animated: true)
  }
  
  func routeToDateVC() {
    let vc = DateViewController()
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func routeToTagVC() {
    let vc = TagViewController()
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func routeToPriorityVC() {
    let vc = PriorityViewController()
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func routeToImagePickerVC() {
    
  }
}

extension NewTodoViewController {
  // 옵저버에서 호출할 메서드
  @objc func handleSelectedPriorityChanged(_ notification: Notification) {
    if let selectedPriority = notification.object as? Priority {
      print("Selected Priority Changed: \(selectedPriority.rawValue)")
      newTodo.priority = selectedPriority
    }
  }
  
  @objc func handleSelectedDateChanged(_ notification: Notification) {
    if let selectedDate = notification.object as? Date {
      print("Selected Date Changed: \(selectedDate)")
      newTodo.deadline = selectedDate
    }
  }
  
  @objc func handleTagTextFieldChanged(_ notification: Notification) {
    if let tagText = notification.object as? String {
      print("Selected Date Changed: \(tagText)")
      newTodo.tag = tagText
    }
  }
}

extension NewTodoViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch sections[section] {
    case .text:
      return 2
    default:
      return 1
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let section = sections[indexPath.section]
    
    if section == .text {
      switch indexPath.row {
      case 0:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTextFieldTableViewCell.identifier, for: indexPath) as? TitleTextFieldTableViewCell else {
          return .init()
        }
        return cell
        
      case 1:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTextViewTableViewCell.identifier, for: indexPath) as? MemoTextViewTableViewCell else {
          return .init()
        }
        
        return cell
      default:
        return .init()
      }
    } else {
      
      let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: UITableViewCell.identifier)
      
      cell.backgroundColor = .white
      
      cell.textLabel?.text = section.rawValue
      cell.textLabel?.textAlignment = .left
      cell.accessoryType = .disclosureIndicator
      
      switch section {
      case .date:
        cell.detailTextLabel?.text = newTodo.deadline.formatted()
      case .tag:
        cell.detailTextLabel?.text = newTodo.tag
      case .priority:
        cell.detailTextLabel?.text = newTodo.priority.stringValue
      default:
        break
      }
      
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let selectedSection = sections[indexPath.section]
    switch selectedSection {
    case .date:
      routeToDateVC()
//    case .image:
//      routeToImagePickerVC()
    case .priority:
      routeToPriorityVC()
    case .tag:
      routeToTagVC()
    default:
      return
    }
    return
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    Section.allCases.count
  }
  
  enum Section: String, Hashable, CaseIterable {
    case text
    case date = "마감일"
    case tag = "태그"
    case priority = "우선 순위"
//    case image = "이미지 추가"
  }
}


@available(iOS 17.0, *)
#Preview {
  NewTodoViewController().wrapToNavigationVC()
}
