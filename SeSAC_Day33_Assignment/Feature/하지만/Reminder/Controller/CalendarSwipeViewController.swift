//
//  CalendarViewController.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/19/24.
//

import UIKit
import FSCalendar
import Then
import SnapKit

class CalendarSwipeViewController: BaseViewController {
  
  lazy var calendarView: FSCalendar = .init().then {
    $0.locale = Locale(identifier: "ko-KR")
    $0.delegate = self
    $0.dataSource = self
  }
  
  var selectedDate: Date? = Date()
  var isMonthlyMode: Bool = true {
    didSet {
      if(isMonthlyMode){
        calendarView.scope = .month
      }else {
        calendarView.scope = .week
      }
    }
  }
  
  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  // MARK: Configurate
  override func configView() {
    configSwipeGesture()
//    configNavigationBar()
  }
  override func configLayout() {
    calendarView.snp.makeConstraints {
      $0.center.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
      $0.height.equalTo(view.bounds.height)
    }
  }
  override func configHierarchy() {
    view.addSubviews([
      calendarView
    ])
  }
  
  // MARK: Action
  @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
    
    if swipe.direction == .up {
      calendarView.setScope(.week, animated: true)
    }
    else if swipe.direction == .down {
      calendarView.setScope(.month, animated: true)
    }
  }
  
  func configSwipeGesture() {
    let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:))).then {
      $0.direction = .up
    }
    self.view.addGestureRecognizer(swipeUp)
    
    let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:))).then {
      $0.direction = .down
    }
    self.view.addGestureRecognizer(swipeDown)
  }
  func configNavigationBar() {
    let closeButton = UIBarButtonItem(title: "닫기", image: UIImage(systemName: "xmark"), target: self, action: #selector(tappedCloseButton)).then {
      $0.tintColor = .black
    }
    navigationItem.rightBarButtonItems = [closeButton]
  }
  
  @objc func tappedCloseButton(_ sender: Any){
    dismiss(animated: true)
  }
}

extension CalendarSwipeViewController: FSCalendarDelegate, FSCalendarDataSource {
  
  func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
    
    calendarView.snp.makeConstraints {
      $0.height.equalTo(bounds.height)
    }
    
    UIView.animate(withDuration: 0.5) {
      self.view.layoutIfNeeded()
    }
  }
}

#Preview {
  CalendarSwipeViewController().wrapToNavigationVC()
}
