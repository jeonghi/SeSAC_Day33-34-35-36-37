//
//  TodoDocumentViewController.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/21/24.
//


import UIKit
import Then
import SnapKit
import RealmSwift

class TodoDocumentViewController: BaseViewController {
  
  var todoDocumentRepository: TodoDocumentRepository? = TodoDocumentRepositoryImpl()
  
  var action: ((TodoDocument?) -> Void)?
  
  lazy var tableView: UITableView = .init(frame: .zero, style: .insetGrouped).then {
    $0.delegate = self
    $0.dataSource = self
    $0.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
  }
  
  var todoDocuments: Results<TodoDocument>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    todoDocuments = todoDocumentRepository?.readAll()
  }
  
  override func configView() {
    configNavigationBar()
  }
  
  override func configLayout() {
    tableView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func configHierarchy() {
    view.addSubview(tableView)
  }
  
  func configNavigationBar() {
    navigationItem.title = "목록 선택"
  }
}

extension TodoDocumentViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    todoDocuments.count
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let document = todoDocuments[indexPath.row]
    let cell = UITableViewCell(style: .default, reuseIdentifier: UITableViewCell.identifier)
    cell.textLabel?.text = document.name
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let document = todoDocuments[indexPath.row]
    action?(document)
  }
}

@available(iOS 17.0, *)
#Preview {
  TodoDocumentViewController().wrapToNavigationVC()
}
