//
//  NewTodoView.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import UIKit
import Then
import SnapKit

class NewTodoView: BaseView {
  
  let tableView = UITableView(frame: .zero, style: .insetGrouped)
  
  override func configView() {
    backgroundColor = .white
  }
  
  override func configLayout() {
    tableView.snp.makeConstraints {
      $0.edges.equalTo(safeAreaLayoutGuide)
    }
  }
  
  override func configHierarchy() {
    addSubviews([tableView])
  }
}

@available(iOS 17.0, *)
#Preview {
  NewTodoView()
}
