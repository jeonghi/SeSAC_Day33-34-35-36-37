//
//  TagViewController.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import UIKit
import Then
import SnapKit

class TagViewController: BaseViewController {
  
  let tagView = TagView()
  
  override func loadView() {
    view = tagView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func configView() {
    configNavigationBar()
  }
  
  func configNavigationBar() {
    navigationItem.title = "태그"
  }
}

@available(iOS 17.0, *)
#Preview {
  TagViewController().wrapToNavigationVC()
}
