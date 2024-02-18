//
//  FormViewController.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/18/24.
//

import UIKit
import Then

final class FormViewController: BaseViewController {
  
  // MARK: Creating a Form View
  
  let form: Form
  
  var closeAction: (() -> Void)?
  
  lazy var todoView: NewTodoView = .init().then {
    $0.tableView.delegate = self
    $0.tableView.dataSource = self
    $0.tableView.register(
      TextInputTableViewCell.self,
      forCellReuseIdentifier: TextInputTableViewCell.identifier
    )
    $0.tableView.register(
      TextViewTableViewCell.self,
      forCellReuseIdentifier: TextViewTableViewCell.identifier
    )
    
    $0.tableView.rowHeight = UITableView.automaticDimension
    $0.tableView.estimatedRowHeight = 500
  }
  
  init(
    form: Form
  ) {
    self.form = form
    super.init(
      nibName: nil,
      bundle: nil
    )
  }
  
  convenience init(
    note: Note
  ) {
    let form = Form(
      sections: [
        FormSection(
          items: [
            TextInputFormItem(
              text: note.topic,
              placeholder: "Add title",
              didChange: {
                text in
                note.text = text
              }),
            TextViewFormItem(
              text: note.text,
              placeholder: "Add description",
              didChange: {
                text in
                note.text = text
              })
          ]
        )
      ]
    )
    self.init(
      form: form
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
    
    navigationItem.title = "새로운 미리 알림"
  }
  
  @objc
  func tappedCancelButton() {
    dismiss(animated: true)
  }
  
  @objc
  func tappedAddButton() {
    closeAction?()
    dismiss(animated: true)
  }
}

extension FormViewController: UITableViewDelegate, UITableViewDataSource {
  // MARK: Providing Table View Content
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }
  
  private func model(
    at indexPath: IndexPath
  ) -> FormItem {
    return form.sections[indexPath.section].items[indexPath.item]
  }
  
  func numberOfSections(
    in tableView: UITableView
  ) -> Int {
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
    return .init()
  }
}



#Preview {
  FormViewController(note: .init(topic: "", text: "")).wrapToNavigationVC()
}
