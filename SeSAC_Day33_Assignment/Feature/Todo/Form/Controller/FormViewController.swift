//
//  FormViewController.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/18/24.
//

import UIKit
import Then
import Toast

final class FormViewController: BaseViewController {
  
  // MARK: Creating a Form View
  
  let todo: TodoItem
  var form: Form = .init(sections: [])
  
  var closeAction: (() -> Void)?
  
  lazy var todoView: NewTodoView = .init().then {
    $0.tableView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.register(TextInputTableViewCell.self, forCellReuseIdentifier: TextInputTableViewCell.identifier)
      $0.register(TextViewTableViewCell.self, forCellReuseIdentifier: TextViewTableViewCell.identifier)
      $0.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
      $0.rowHeight = UITableView.automaticDimension
      $0.estimatedRowHeight = 500
      $0.sectionHeaderHeight = .init(10)
      $0.sectionFooterHeight = .init(10)
    }
  }
  
  var todoRepository: TodoRepository = TodoRepositoryImpl()
  
  init(
    todo: TodoItem = .init()
  ) {
    self.todo = todo
    super.init(
      nibName: nil,
      bundle: nil
    )
  }
  
  required init?(
    coder: NSCoder
  ) {
    fatalError(
      "init(coder:) has not been implemented"
    )
  }
  
  override func loadView() {
    self.view = todoView
  }
  
  // MARK: Managing the View
  
  override func viewDidLoad() {
    super.viewDidLoad()
    refresh()
  }
  
  override func configView() {
    configNavigationBar()
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
  }
  
  @objc
  func tappedCancelButton() {
    dismiss(animated: true)
  }
  
  @objc
  func tappedAddButton() {
    if(!validateRequiredConditionSatisfied()){
      self.view.makeToast("제목을 입력해주세요", position: .top)
      return
    }
    todoRepository.create(todoItem: todo)
    closeAction?()
    dismiss(animated: true)
  }
  
  func validateRequiredConditionSatisfied() -> Bool {
    !todo.title.isEmpty
  }
}

extension FormViewController: UITableViewDelegate, UITableViewDataSource {
  // MARK: Providing Table View Content
  func refresh() {
    let form = Form(
      sections: [
        FormSection(items: [
          TextInputFormItem(
            text: self.todo.title, placeholder: "제목", didChange: { self.todo.title = $0 }),
          TextViewFormItem(text: self.todo.memo ?? "", placeholder: "메모", didChange: { self.todo.memo = $0})
        ]),
        FormSection(items: [CustomFormItem(title: "마감일", detail: self.todo.dueDate?.toString(), didChange: { self.todo.dueDate = $0 })]),
        FormSection(items: [CustomFormItem(title: "태그", detail: self.todo.tag, didChange: { self.todo.tag = $0})]),
        FormSection(items: [CustomFormItem(title: "우선순위", detail: self.todo.priority?.description, didChange: { self.todo.priority = $0})])
      ]
    )
    self.form = form
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }
  
  private func model(at indexPath: IndexPath) -> FormItem {
    return form.sections[indexPath.section].items[indexPath.item]}
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return form.sections.count
  }
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return form.sections[section].items.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let object = model(at: indexPath)
    if let textRow = object as? TextInputFormItem {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: TextInputTableViewCell.identifier,
        for: indexPath
      ) as! TextInputTableViewCell
      cell.configure(for: textRow)
      return cell
    }
    else if let textRow = object as? TextViewFormItem {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: TextViewTableViewCell.identifier,
        for: indexPath
      ) as! TextViewTableViewCell
      cell.configure(for: textRow)
      return cell
    } else {
      if let textRow = object as? CustomFormItem<Date> {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: UITableViewCell.identifier).then {
          $0.textLabel?.text = textRow.title
          $0.textLabel?.textAlignment = .left
          $0.accessoryType = .disclosureIndicator
          $0.detailTextLabel?.text = textRow.detail ?? ""
        }
        return cell
      }
      else if let textRow = object as? CustomFormItem<Priority> {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: UITableViewCell.identifier).then {
          $0.textLabel?.text = textRow.title
          $0.textLabel?.textAlignment = .left
          $0.accessoryType = .disclosureIndicator
          $0.detailTextLabel?.text = textRow.detail ?? ""
        }
        return cell
      }
      else if let textRow = object as? CustomFormItem<String> {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: UITableViewCell.identifier).then {
          $0.textLabel?.text = textRow.title
          $0.textLabel?.textAlignment = .left
          $0.accessoryType = .disclosureIndicator
          $0.detailTextLabel?.text = textRow.detail ?? ""
        }
        return cell
      }
    }
    return .init()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let object = model(at: indexPath)
    var vc: UIViewController?
    if let textRow = object as? CustomFormItem<Date> {
      vc = DateViewController().then {
        $0.selectedDate = todo.dueDate
        $0.action = {
          self.todo.dueDate = $0
          self.refresh()
          tableView.reloadRows(at: [indexPath], with: .automatic)
        }
      }
    }
    else if let textRow = object as? CustomFormItem<Priority> {
      vc = PriorityViewController().then {
        $0.selectedPriority = todo.priority
        $0.action = {
          self.todo.priority = $0
          self.refresh()
          tableView.reloadRows(at: [indexPath], with: .automatic)
        }
      }
    }
    else if let textRow = object as? CustomFormItem<String> {
      vc = TagViewController().then {
        $0.tag = todo.tag
        $0.action = {
          self.todo.tag = $0
          self.refresh()
          tableView.reloadRows(at: [indexPath], with: .automatic)
        }
      }
    }
    guard let vc else { return }
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  //  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
  //    return 10
  //  }
  //
  //  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
  //    return 10
  //  }
}

#Preview {
  FormViewController(todo: .init(title: "하하")).wrapToNavigationVC()
}
