//
//  RemiderCollectionViewCell.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/18/24.
//
import UIKit
import SnapKit
import Then

final class RemindListCollectionViewCell: BaseCollectionViewCell {
  
  private let innerView = UIView()
  private lazy var stackView = UIStackView(arrangedSubviews: [iconImageView, countLabel]).then {
    $0.axis = .horizontal
    $0.distribution = .fill
    $0.alignment = .fill
  }
  private let iconImageView = UIImageView(frame: .zero).then {
    $0.contentMode = .scaleAspectFill
  }
  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 17, weight: .medium)
    $0.textAlignment = .left
    $0.numberOfLines = 1
  }
  private let countLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 20, weight: .bold)
    $0.textAlignment = .right
    $0.numberOfLines = 1
  }
  
  func config(iconImage: UIImage?, title: String?, count: Int?) {
    
    // 이걸로 image와 imageView간에 inset 줄 수 있음.
    iconImageView.image = iconImage?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    titleLabel.text = title
    countLabel.text = "\(count ?? 0)"
  }
  
  override func configView() {
    backgroundColor = .lightGray.withAlphaComponent(0.1)
    layer.cornerRadius = 16
    layer.cornerCurve = .continuous
    self.config(iconImage: nil, title: nil, count: nil)
  }
  
  override func configLayout() {
    innerView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(20)
    }
    
    iconImageView.snp.makeConstraints {
      $0.size.equalTo(45)
    }
    
    stackView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(stackView.snp.bottom).offset(20)
      $0.horizontalEdges.equalToSuperview()
//      $0.bottom.lessThanOrEqualToSuperview().inset(0) // innerView의 높이가 동적으로 조정되도록
    }
  }
  
  override func configHierarchy() {
    innerView.addSubviews([stackView, titleLabel])
    addSubview(innerView)
  }
}
