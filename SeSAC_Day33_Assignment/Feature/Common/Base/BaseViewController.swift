//
//  BaseViewController.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import UIKit
import Then

class BaseViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configBase()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
}

extension BaseViewController: BaseViewConfigurable {
  func configView() {}
  func configLayout() {}
  func configHierarchy() {}
}

