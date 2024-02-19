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

struct CustomFormItem<T>: FormItem{
  let title: String
  var detail: String? = nil
  let didChange: (T?) -> ()
}

struct TextInputFormItem: FormItem {
  let text: String
  let placeholder: String
  let didChange: (String) -> ()
}

struct TextViewFormItem: FormItem {
  let text: String
  let placeholder: String
  let didChange: (String?) -> ()
}

protocol FormItem {
}
