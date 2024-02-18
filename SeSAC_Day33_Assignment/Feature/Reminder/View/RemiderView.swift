//
//  RemiderView.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import UIKit
import Then
import SnapKit

final class RemiderView: BaseView {
  
  lazy var tableView = UITableView()
  
  override func configView() {
    backgroundColor = .white
  }
  
  override func configLayout() {
    tableView.snp.makeConstraints {
      $0.edges.equalTo(safeAreaLayoutGuide)
    }
  }
  
  override func configHierarchy() {
    self.addSubviews([tableView])
  }
}

@available(iOS 17.0, *)
#Preview {
  RemiderView()
}
