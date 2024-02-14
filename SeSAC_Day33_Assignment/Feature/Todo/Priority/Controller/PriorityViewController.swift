//
//  PriorityViewController.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import UIKit
import Then
import SnapKit

class PriorityViewController: BaseViewController {
  
  let priorityView = PriorityView()
  
  override func loadView() {
    view = priorityView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func configView() {
    configNavigationBar()
  }
  
  func configNavigationBar() {
    navigationItem.title = "우선 순위"
  }
}

@available(iOS 17.0, *)
#Preview {
  PriorityViewController().wrapToNavigationVC()
}
