//
//  ImageTableViewCell.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/20/24.
//

import UIKit
import SnapKit
import Then

final class ImageTableViewCell: BaseTableViewCell {
  
  var imgView: UIImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  // MARK: Initializing a Cell
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  override func configHierarchy() {
    addSubview(imgView)
  }
  
  override func configLayout() {
    imgView.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.equalTo(imgView.snp.width)
      $0.horizontalEdges.equalToSuperview()
      $0.center.equalToSuperview()
      $0.verticalEdges.equalToSuperview()
    }
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Reusing Cells
  
  override func prepareForReuse() {
    super.prepareForReuse()
    configure(for: nil)
    changeHandler = { _ in }
  }
  
  // MARK: Managing the Content
  
  func configure(for model: ImageDisplayFormItem?) {
    self.imgView.image = model?.image
    layoutIfNeeded()
  }
  
  // MARK: Handling Text Input
  
  private var changeHandler: (String) -> () = { _ in }
}

