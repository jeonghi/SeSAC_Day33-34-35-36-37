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
  
  var list: Results<TodoItem>? {
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
    let systemSection = Section.system([
      .init(groupTitle: "오늘", numberOfItems: list?.filter{Calendar.current.isDateInToday($0.dueDate ?? Date())}.count ?? 0, tintColor: .systemBlue),
      .init(iconImageName: "archivebox.circle.fill", groupTitle: "전체", numberOfItems: list?.count ?? 0, tintColor: .systemGray),
      .init(iconImageName: "checkmark.circle.fill", groupTitle: "완료됨", numberOfItems: list?.filter{$0.isDone}.count ?? 0, tintColor: .darkGray)
    ])
    
    let customSection = Section.custom([])
    
    datasource = [systemSection, customSection]
    
    self.remiderView.collectionView.reloadData()
  }
}

// MARK:
extension ReminderViewController {
  func loadData() {
    list = todoRepository.readAll()
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
    
    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(customView: rightItem)
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
    
    cell.config(iconImage: UIImage(systemName: model?.iconImageName ?? "")?.withTintColor(model?.tintColor ?? .link, renderingMode: .alwaysOriginal), title: model?.groupTitle, count: model?.numberOfItems)
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
    
    let vc = TodoItemListViewController()
    vc.navigationItem.title = model?.groupTitle
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
    var iconImageName: String = "calendar.circle.fill"
    let groupTitle: String
    let numberOfItems: Int
    var tintColor: UIColor = .link
  }
}

extension ReminderViewController {
  
  @objc func tappedAddNewTodoButton() { sheetNewTodo() }
  
  @objc func tappedAddNewListButton() {}
  
  @objc func tappedMoreButton() {}
  
  @objc func tappedEditButton() {}
  
  @objc func tappedTemplateButton() {}
  
  @objc func sheetNewTodo(){
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
