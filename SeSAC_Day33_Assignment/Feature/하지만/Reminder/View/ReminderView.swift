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
  
  
  
  override func configView() {
    backgroundColor = .white
  }
  
  override func configLayout() {
    collectionView.snp.makeConstraints {
      $0.edges.equalTo(safeAreaLayoutGuide)
    }
  }
  
  override func configHierarchy() {
    self.addSubviews([collectionView])
  }
}

@available(iOS 17.0, *)
#Preview {
  ReminderView()
}
