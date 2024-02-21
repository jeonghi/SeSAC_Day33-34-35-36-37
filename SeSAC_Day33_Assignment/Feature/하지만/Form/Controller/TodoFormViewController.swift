//
//  FormViewController.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/18/24.
//

import UIKit
import Then
import Toast
import RealmSwift

final class TodoFormViewController: BaseViewController {
  
  // MARK: View
  lazy var todoView: NewTodoView = .init()
  
  // MARK: Properties
  // 하 코드를 잘못짰다.. 뷰 자체적으로 데이터를 위한 모델을 두고, 그걸 최종 업데이트 하도록 해야했는데........ 엔티티를 다이렉트로 수정하게 코드를 짜놔서 답이 없다,,,,
  var originalTodoItemId: ObjectId?
  var todoItem: TodoItem
  var todoDocument: TodoDocument?
  var form: Form = .init(sections: [])
  private var editMode: EditMode = .new
  var closeAction: (() -> Void)?
  
  // MARK: Dependency
  var todoRepository: TodoRepository = TodoRepositoryImpl()
  var todoDocumentRepository: TodoDocumentRepository = TodoDocumentRepositoryImpl()
  
  // MARK: Initializer
  init(
    todo: TodoItem? = nil
  ) {
    if let todo {
      self.todoItem = TodoItem(copy: todo)
      self.originalTodoItemId = todo._id
      self.editMode = .edit
    } else {
      self.todoItem = .init()
      self.editMode = .new
    }
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: Life cycle
  override func loadView() {
    self.view = todoView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    refresh()
  }
  
  // MARK: Base Configuration
  override func configView() {
    todoView.do {
      $0.tableView.do {
        $0.delegate = self
        $0.dataSource = self
        $0.register(TextInputTableViewCell.self, forCellReuseIdentifier: TextInputTableViewCell.identifier)
        $0.register(TextViewTableViewCell.self, forCellReuseIdentifier: TextViewTableViewCell.identifier)
        $0.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.identifier)
        $0.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 500
        $0.sectionHeaderHeight = .init(10)
        $0.sectionFooterHeight = .init(10)
      }
    }
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
    
    let rightItem = rightBarButtonItemBuilder(for: self.editMode)
    
    navigationItem.leftBarButtonItems = [leftItem]
    navigationItem.rightBarButtonItems = [rightItem]
  }
}

extension TodoFormViewController {
  func rightBarButtonItemBuilder(for mode: EditMode) -> UIBarButtonItem {
    switch mode {
    case .edit, .readOnly:
      return UIBarButtonItem(
        title: "수정",
        style: .plain,
        target: self,
        action: #selector(tappedUpdateButton)
      )
    case .new:
      return UIBarButtonItem(
        title: "추가",
        style: .plain,
        target: self,
        action: #selector(tappedAddButton)
      )
    }
  }
  
  @objc
  func tappedCancelButton() {
    dismiss(animated: true)
  }
  
  @objc
  func tappedUpdateButton() {
    if(!validateRequiredConditionSatisfied()){
      self.view.makeToast("제목을 입력해주세요", position: .top)
      return
    }
    if let originalTodoItemId {
      todoRepository.updateById(id: originalTodoItemId, with: todoItem)
    }
    dismiss(animated: true, completion: closeAction)
  }
  
  @objc
  func tappedAddButton() {
    if(!validateRequiredConditionSatisfied()){
      self.view.makeToast("제목을 입력해주세요", position: .top)
      return
    }
    if let todoItem = todoRepository.create(todoItem: todoItem), let todoDocument {
      todoDocumentRepository.addTodoItem(to: todoDocument, item: todoItem)
    }
    dismiss(animated: true, completion: closeAction)
  }
  
  func validateRequiredConditionSatisfied() -> Bool {
    !todoItem.title.isEmpty
  }
}

extension TodoFormViewController {
  private func model(at indexPath: IndexPath) -> FormItem {
    return form.sections[indexPath.section].items[indexPath.item]}
  
  func formBuilder(for todoItem: TodoItem) -> Form {
    Form(
      sections: [
        FormSection(
          items: [
            TextInputFormItem(
              text: todoItem.title,
              placeholder: "제목",
              didChange: {
                todoItem.title = $0
              }),
            TextViewFormItem(text: todoItem.memo ?? "",
                             placeholder: "메모",
                             didChange: {
                               self.todoItem.memo = $0
                             })
          ]
        ),
        FormSection(
          items: [CustomFormItem(title: "마감일",
                                 detail: todoItem.dueDate?.toString(),
                                 didChange: {
                                   self.todoItem.dueDate = $0
                                 })]
        ),
        FormSection(
          items: [CustomFormItem(title: "태그",
                                 detail: todoItem.tag,
                                 didChange: {
                                   self.todoItem.tag = $0
                                 })]
        ),
        FormSection(
          items: [CustomFormItem(title: "우선순위",
                                 detail: todoItem.priority?.description,
                                 didChange: {
                                   self.todoItem.priority = $0
                                 })]
        ),
        FormSection(
          items: [CustomFormItem(title: "목록",
                                 detail: todoDocument?.name,
                                 didChange: {
                                   self.todoDocument = $0
                                 })]
        ),
        FormSection(items: {
          var items: [FormItem] = [CustomFormItem<UIImage>(title: "이미지",
                                                           didChange: { _ in })]
          if let fileName = todoItem.imagePath {
            if let image = loadImageFromDocument(filename: fileName) {
              items.append(ImageDisplayFormItem(image: image))
            }
          }
          return items
        }()
                   ),
      ]
    )
  }
  
}

extension TodoFormViewController: UITableViewDelegate, UITableViewDataSource {
  func refresh() {
    self.form = formBuilder(for: self.todoItem)
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }
  
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
    }
    else if let textRow = object as? ImageDisplayFormItem {
      let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as! ImageTableViewCell
      cell.configure(for: textRow)
      cell.selectionStyle = .none
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
      else if let textRow = object as? CustomFormItem<UIImage> {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: UITableViewCell.identifier).then {
          $0.textLabel?.text = textRow.title
          $0.textLabel?.textAlignment = .left
          $0.accessoryType = .disclosureIndicator
          $0.detailTextLabel?.text = textRow.detail ?? ""
        }
        return cell
      }
      else if let textRow = object as? CustomFormItem<TodoDocument> {
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
      let vc = DateViewController().then {
        $0.selectedDate = todoItem.dueDate
        $0.action = { [weak self] newDate in
          self?.todoItem.dueDate = newDate
          self?.refresh()
          tableView.reloadRows(at: [indexPath], with: .automatic)
        }
      }
      self.navigationController?.pushViewController(vc, animated: true)
    }
    else if let textRow = object as? CustomFormItem<Priority> {
      let vc = PriorityViewController().then {
        $0.selectedPriority = todoItem.priority
        $0.action = { [weak self] newPriority in
          self?.todoItem.priority = newPriority
          self?.refresh()
          tableView.reloadRows(at: [indexPath], with: .automatic)
        }
      }
      self.navigationController?.pushViewController(vc, animated: true)
    }
    else if let textRow = object as? CustomFormItem<String> {
      let vc = TagViewController().then {
        $0.tag = todoItem.tag
        $0.action = {
          self.todoItem.tag = $0
          self.refresh()
          tableView.reloadRows(at: [indexPath], with: .automatic)
        }
      }
      self.navigationController?.pushViewController(vc, animated: true)
    }
    else if let textRow = object as? CustomFormItem<TodoDocument> {
      let vc = TodoDocumentViewController().then {
        $0.action = {
          self.todoDocument = $0
          self.refresh()
          tableView.reloadRows(at: [indexPath], with: .automatic)
        }
      }
      self.navigationController?.pushViewController(vc, animated: true)
    }
    
    else if let textRow = object as? CustomFormItem<UIImage> {
      let vc = UIImagePickerController().then {
        $0.delegate = self
        $0.sourceType = .photoLibrary
        $0.allowsEditing = true
      }
      present(vc, animated: true)
    }
  }

}

extension TodoFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    dump(info[UIImagePickerController.InfoKey.editedImage])
    if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      
      // 아래 예외 처리 필요 ⭐️
      // 디스크에 바로 IO하는거 비효율적임 개선 필요,,;; 일단 한다. ⭐️
      // 1) 임시로 뷰컨에서 물고 있다가, 저장할때, 비로소 디스크에 저장하고,
      // 2) 근데,,, 이미지 업데이트하면 기존꺼는 지워야하지 않을까
      // 3) FileManager 자체적으로 메모리 캐시를 사용하고 있는지 확인 필요,,
      // 4) 사용하고 있지 않다면,????? 메모리 캐시 만들어서 선 저장후, 주기적으로 write back 해야하지 않을까
      
      let fileName = todoItem._id.stringValue
      saveImageToDocument(image: pickedImage, filename: "\(fileName)")
      todoItem.imagePath = fileName
      refresh()
      todoView.tableView.reloadData()
    }
    dismiss(animated: true)
  }
}

extension TodoFormViewController {
  enum EditMode {
    case edit
    case new
    case readOnly
  }
}

#Preview {
  TodoFormViewController(todo: .init(title: "하하")).wrapToNavigationVC()
}
