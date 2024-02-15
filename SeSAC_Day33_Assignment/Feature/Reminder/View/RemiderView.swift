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
  
  let searchBar = UISearchBar().then {
    $0.placeholder = "검색"
    $0.barStyle = .default
    $0.searchBarStyle = .minimal
  }
  
  lazy var tableView = UITableView().then {
    $0.tableHeaderView = searchBar
  }
  
  override func configView() {
    backgroundColor = .white
  }
  
  override func configLayout() {
    tableView.snp.makeConstraints {
      $0.edges.equalTo(safeAreaLayoutGuide)
    }
    
    searchBar.snp.makeConstraints {
      $0.horizontalEdges.equalTo(tableView.safeAreaLayoutGuide)
      $0.height.equalTo(70)
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
