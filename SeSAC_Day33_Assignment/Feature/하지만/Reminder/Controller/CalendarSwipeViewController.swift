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
  
  let contentView: UIView = .init(frame: .zero)
  
  var todoRepository: TodoRepository = TodoRepositoryImpl()
  weak var todoItemListViewController: TodoItemListViewController?
  
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
    configNavigationBar()
    ViewEmbedder.embed(child: TodoItemListViewController.self, parent: self, container: contentView) {
      self.todoItemListViewController = $0 as? TodoItemListViewController
      self.todoItemListViewController?.defaultPredicate = self.predicateBuilder(for: self.calendarView.selectedDate ?? Date())
    }
  }
  override func configLayout() {
    calendarView.snp.makeConstraints {
      $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
      $0.height.equalTo(400)
    }
    contentView.snp.makeConstraints {
      $0.top.equalTo(calendarView.snp.bottom).offset(20)
      $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
      $0.bottomMargin.equalTo(view.safeAreaLayoutGuide)
    }
  }
  override func configHierarchy() {
    view.addSubviews([
      calendarView,
      contentView
    ])
  }
  
  // MARK: Action
  @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
    
    if swipe.direction == .up {
      calendarView.setScope(.week, animated: true)
      UIView.animate(withDuration: 0.5) {
        self.view.layoutIfNeeded()
      }
    }
    else if swipe.direction == .down {
      calendarView.setScope(.month, animated: true)
      UIView.animate(withDuration: 0.5) {
        self.view.layoutIfNeeded()
      }
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
    navigationItem.title = "날짜별로 일정보기"
    navigationController?.navigationBar.prefersLargeTitles = false
  }
  
  @objc func tappedCloseButton(_ sender: Any){
    dismiss(animated: true)
  }
}

extension CalendarSwipeViewController: FSCalendarDelegate, FSCalendarDataSource {
  
  func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
    
    calendarView.snp.updateConstraints {
      $0.height.equalTo(bounds.height)
    }
    
    UIView.animate(withDuration: 0.5) {
      self.view.layoutIfNeeded()
    }
  }
  
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    self.todoItemListViewController?.defaultPredicate = predicateBuilder(for: date)
  }
  
  func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
    todoRepository.readFiltered(by: predicateBuilder(for: date)).count
  }
  
  func predicateBuilder(for date: Date) -> NSPredicate {
    let startOfDay = Calendar.current.startOfDay(for: date)
    let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: date)!
    return NSPredicate(format: "dueDate >= %@ AND dueDate < %@ AND isDone == false", startOfDay as NSDate, endOfDay as NSDate)
  }
}

#Preview {
  CalendarSwipeViewController().wrapToNavigationVC()
}
