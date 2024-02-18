//
//  ColorPickerViewController.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/18/24.
//

import UIKit
import SnapKit
import Then

class ColorPickerViewController: BaseViewController {
  
  var selectedColor: UIColor? = .black{
    didSet {
      self.colorView.backgroundColor = selectedColor
    }
  }
  
  lazy var button = UIButton().then {
    $0.setTitle("색상 고르기", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.center = self.view.center
    $0.addTarget(self, action: #selector(tappedSelectColor), for: .touchUpInside)
    $0.backgroundColor = .link
    $0.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
    $0.layer.cornerRadius = 10
    $0.layer.cornerCurve = .continuous
  }
  
  lazy var colorView = BaseView().then {
    $0.backgroundColor = self.selectedColor
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func configView() {
    view.backgroundColor = .white
    DispatchQueue.main.async {
      self.colorView.clipsToBounds = true
      self.colorView.layer.cornerRadius = self.colorView.frame.width/2
    }
  }
  
  override func configLayout() {
    button.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    colorView.snp.makeConstraints {
      $0.height.width.equalTo(button.snp.height)
      $0.top.equalTo(button.snp.bottom)
      $0.centerX.equalToSuperview()
    }
  }
  
  override func configHierarchy() {
    view.addSubviews([button, colorView])
  }
  
  @objc
  private func tappedSelectColor() {
    let colorPickerVC = UIColorPickerViewController()
    colorPickerVC.delegate = self
    present(colorPickerVC, animated: true)
  }
}

extension ColorPickerViewController: UIColorPickerViewControllerDelegate {
  func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
    print(#function)
    selectedColor = viewController.selectedColor
    return
  }
  
  func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
//    selectedColor = color
    return
  }
}

@available(iOS 17.0, *)
#Preview {
  ColorPickerViewController().wrapToNavigationVC()
}
