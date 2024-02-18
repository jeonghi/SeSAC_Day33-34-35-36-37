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
  
  lazy var todoView: NewTodoView = .init().then {
    $0.tableView.delegate = self
    $0.tableView.dataSource = self
    $0.tableView.register(TextInputTableViewCell.self, forCellReuseIdentifier: ReuseIdentifiers.textInput.rawValue)
  }
  
  init(
    form: Form
  ) {
    self.form = form
    super.init(nibName: nil, bundle: nil)
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
            TextInputFormItem(
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
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    self.view = todoView
  }
  
  // MARK: Managing the View
  
  private enum ReuseIdentifiers: String {
    case textInput
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

extension FormViewController: UITableViewDelegate, UITableViewDataSource {
  // MARK: Providing Table View Content
  
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
    let object = model(
      at: indexPath
    )
    if let textRow = object as? TextInputFormItem {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: ReuseIdentifiers.textInput.rawValue,
        for: indexPath
      ) as! TextInputTableViewCell
      cell.configure(
        for: textRow
      )
      return cell
    }
    return .init()
  }
}

struct TextInputFormItem: FormItem {
  let text: String
  let placeholder: String
  let didChange: (
    String
  ) -> ()
}

final class Note {
  init(
    topic: String,
    text: String
  ) {
    self.topic = topic
    self.text = text
  }
  
  var topic: String = "" {
    didSet {
      print(
        "Topic changed to \(topic)."
      )
    }
  }
  
  var text: String = "" {
    didSet {
      print(
        "Text changed to \(text)."
      )
    }
  }
}

final class Form {
  let sections: [FormSection]
  init(
    sections: [FormSection]
  ) {
    self.sections = sections
  }
}

final class FormSection {
  let items: [FormItem]
  init(
    items: [FormItem]
  ) {
    self.items = items
  }
}

protocol FormItem {
}

#Preview {
  FormViewController(note: .init(topic: "흠", text: "하하"))
}
