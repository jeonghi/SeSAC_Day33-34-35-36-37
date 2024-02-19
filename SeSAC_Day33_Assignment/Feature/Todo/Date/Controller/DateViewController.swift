//
//  DateViewController.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import UIKit
import Then
import SnapKit

class DateViewController: BaseViewController {
  
  lazy var dateView = DateView()
  
  var selectedDate: Date? {
    get {
      dateView.datePicker.date
    }
    
    set {
      dateView.datePicker.date = newValue ?? Date()
    }
  }
  
  var action: ((Date?) -> Void)? {
    didSet {
      self.dateView.action = self.action
    }
  }
  
  override func loadView() {
    view = dateView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func configView() {
    configNavigationBar()
  }
  
  override func configLayout() {
    
  }
  
  override func configHierarchy() {
    
  }
  
  func configNavigationBar() {
    navigationItem.title = "마감일"
  }
}

@available(iOS 17.0, *)
#Preview {
  DateViewController().wrapToNavigationVC()
}
