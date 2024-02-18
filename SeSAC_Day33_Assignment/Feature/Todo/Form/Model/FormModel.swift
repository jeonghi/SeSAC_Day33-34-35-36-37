//
//  FormModel.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/18/24.
//

import Foundation

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

struct TextInputFormItem: FormItem {
  let text: String
  let placeholder: String
  let didChange: (String) -> ()
}

struct TextViewFormItem: FormItem {
  let text: String
  let placeholder: String
  let didChange: (String) -> ()
}
