//
//  RemiderView.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import UIKit
import Then
import SnapKit

final class ReminderView: BaseView {
  
  lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
    $0.scrollDirection = .vertical
    $0.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
  })
  
  lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
  
  override func configView() {
    backgroundColor = .white
  }
  
  override func configLayout() {
    collectionView.snp.makeConstraints {
      $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
      $0.height.equalTo(300)
    }
    tableView.snp.makeConstraints {
      $0.top.equalTo(collectionView.snp.bottom)
      $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
    }
  }
  
  override func configHierarchy() {
    self.addSubviews([collectionView, tableView])
  }
}

@available(iOS 17.0, *)
#Preview {
  ReminderView()
}
