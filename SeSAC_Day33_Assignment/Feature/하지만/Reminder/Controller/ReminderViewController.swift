//
//  ReminderViewController.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import UIKit
import Then
import RealmSwift

final class ReminderViewController: BaseViewController {
  
  var todoRepository: TodoRepository = TodoRepositoryImpl()
  
  lazy var remiderView = ReminderView().then {
    $0.collectionView.do {
      $0.dataSource = self
      $0.delegate = self
      $0.register(RemindListCollectionViewCell.self, forCellWithReuseIdentifier: RemindListCollectionViewCell.identifier)
    }
  }
  
  var todoItems: Results<TodoItem>? {
    didSet {
      refresh()
    }
  }
  
  var datasource: [Section] = [.custom([]), .system([])] {
    didSet {
      self.remiderView.collectionView.reloadData()
    }
  }
  
  // MARK: Life cycle
  override func loadView() {
    view = remiderView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadData()
  }
  
  override func configView() {
    configToolBar()
    configNavigationBar()
    refresh()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadData()
  }
  
  func refresh() {
    let systemSection = Section.system(
      FilterOption.allCases.map{ListModel(filterOption: $0)}
    )
    
    let customSection = Section.custom([])
    
    datasource = [systemSection, customSection]
    
    self.remiderView.collectionView.reloadData()
  }
}

// MARK:
extension ReminderViewController {
  func loadData() {
    todoItems = todoRepository.readAll()
  }
}

extension ReminderViewController {
  
  func configToolBar(){
    // 기본적으로 숨겨져 있으므로 보이도록 설정
    navigationController?.isToolbarHidden = false
    
    let leftItem = UIButton().then {
      $0.setTitle("새로운 미리 알림", for: .normal)
      $0.setTitleColor(UIColor.systemBlue, for: .normal)
      $0.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
      $0.addTarget(self, action: #selector(tappedAddNewTodoButton), for: .touchUpInside)
    }
    
    let rightItem = UIBarButtonItem(
      title: "목록추가",
      style: .plain,
      target: self,
      action: #selector(tappedAddNewListButton)
    )
    
    toolbarItems = [UIBarButtonItem(customView: leftItem),.flexibleSpace(),rightItem]
  }
  
  func configNavigationBar(){
    navigationItem.title = ""
    navigationController?.navigationBar.prefersLargeTitles = true
    // 후속 뷰에서는 적용안되도록 설정
    navigationItem.largeTitleDisplayMode = .always
    
    let rightItem = UIButton().then {
      $0.setImage(UIImage(systemName: "ellipsis.circle.fill"), for: .normal)
      let edit = UIAction(title: "목록 편집", image: UIImage(systemName: "square.on.square"), handler: { _ in })
      let template = UIAction(title: "템플릿", image: UIImage(systemName: "pencil"), handler: { _ in })
      let buttonMenu = UIMenu(title: "", children: [edit, template])
      $0.menu = buttonMenu
      $0.showsMenuAsPrimaryAction = true
    }
    
    let leftItem = UIButton().then {
      $0.setImage(UIImage(systemName: "calendar.circle.fill"), for: .normal)
      $0.addTarget(self, action: #selector(tappedCalendarButton), for: .touchUpInside)
    }
    
    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(customView: rightItem)
    ]
    
    navigationItem.leftBarButtonItems = [
      UIBarButtonItem(customView: leftItem)
    ]
  }
}

extension ReminderViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch datasource[section] {
    case .custom(let models):
      return models.count
    case .system(let models):
      return models.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let section = datasource[indexPath.section]
    
    var model: ListModel?
    
    switch section {
    case .custom(let models):
      model = models[indexPath.row]
    case .system(let models):
      model = models[indexPath.row]
    }
    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RemindListCollectionViewCell.identifier, for: indexPath) as? RemindListCollectionViewCell else {
      return .init()
    }
    
    let option = model?.filterOption
    
    cell.config(iconImage: option?.icon?.withTintColor(option?.tintColor ?? .link, renderingMode: .alwaysOriginal), title: option?.rawValue, count: todoItems?.filter(option?.predicate ?? NSPredicate(value: true)).count ?? 0)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print(indexPath)
    
    let section = datasource[indexPath.section]
    
    var model: ListModel?
    
    switch section {
    case .custom(let models):
      model = models[indexPath.row]
    case .system(let models):
      model = models[indexPath.row]
    }
    
    let option = model?.filterOption
    let vc = TodoItemListViewController()
    vc.defaultPredicate = option?.predicate
    vc.navigationItem.title = option?.rawValue
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

extension ReminderViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.bounds.width / 2 - (10 * 2)
    let title = ""
    let height = calculateDynamicHeight(forWidth: width, title: title)
    return CGSize(width: width, height: height)
  }
  
  func calculateDynamicHeight(forWidth width: CGFloat, title: String) -> CGFloat {
    let padding: CGFloat = 20
    let stackViewHeight: CGFloat = 45
    let spaceBetweenStackViewAndTitle: CGFloat = 20
    let titleLabelHorizontalPadding: CGFloat = 10 * 2
    
    // titleLabel 높이 계산
    let titleFont = UIFont.systemFont(ofSize: 17, weight: .medium)
    let titleWidth = width - titleLabelHorizontalPadding
    let titleHeight = title.boundingRect(
      with: CGSize(
        width: titleWidth,
        height: .greatestFiniteMagnitude
      ),
      options: .usesLineFragmentOrigin,
      attributes: [.font: titleFont],
      context: nil
    ).height
    
    // 총 높이 계산
    let totalHeight = padding + stackViewHeight + spaceBetweenStackViewAndTitle + titleHeight + padding // 마지막 padding은 하단 여백
    return totalHeight
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    10
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    10
  }
}

extension ReminderViewController {
  enum Section {
    case system([ListModel])
    case custom([ListModel])
  }
  
  struct ListModel {
    var filterOption: FilterOption
  }
  
  enum FilterOption: String, CaseIterable {
    
    case today = "오늘"
    case upcoming = "예정"
    case all = "전체"
    case done = "완료됨"
    
    var icon: UIImage? {
      switch self {
      case .all:
        return UIImage(systemName: "archivebox.circle.fill")
      case .done:
        return UIImage(systemName: "checkmark.circle.fill")
      case .upcoming, .today:
        return UIImage(systemName: "calendar.circle.fill")
      }
    }
    
    var tintColor: UIColor {
      switch self {
      case .all:
        return .lightGray
      case .done:
        return .darkGray
      case .upcoming:
        return .systemYellow
      case .today:
        return .link
      }
    }
    
    var predicate: NSPredicate {
      switch self {
      case .all:
        return NSPredicate(value: true)
      case .done:
        return NSPredicate(format: "isDone == true")
      case .upcoming:
        return NSPredicate(format: "dueDate > %@ AND isDone == false", Date() as NSDate)
      case .today:
        return {
          let startOfDay = Calendar.current.startOfDay(for: Date())
          let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
          return NSPredicate(format: "dueDate >= %@ AND dueDate < %@ AND isDone == false", startOfDay as NSDate, endOfDay as NSDate)
        }()
      }
    }
  }
}

extension ReminderViewController {
  
  @objc func tappedAddNewTodoButton() { sheetNewTodo() }
  @objc func tappedAddNewListButton() {}
  @objc func tappedMoreButton() {}
  @objc func tappedEditButton() {}
  @objc func tappedTemplateButton() {}
  
  @objc func tappedCalendarButton() {
    let vc = CalendarSwipeViewController()
    present(vc.wrapToNavigationVC(), animated: true)
  }
  
  @objc func sheetNewTodo() {
    let vc = FormViewController().then {
      $0.closeAction = { self.loadData() }
    }
    vc.navigationItem.title = "새로운 할 일"
    present(vc.wrapToNavigationVC(), animated: true)
  }
}

@available(iOS 17.0, *)
#Preview {
  ReminderViewController().wrapToNavigationVC()
}
