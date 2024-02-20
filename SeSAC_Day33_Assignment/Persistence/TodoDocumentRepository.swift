//
//  TodoDocumentRepository.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/21/24.
//

import RealmSwift
import Foundation

protocol TodoDocumentRepository {
  func create(item: TodoDocument)
  func addTodoItem(to document: TodoDocument, item: TodoItem)
  func removeTodoItem(from document: TodoDocument, item: TodoItem)
  func fetchAllDocuments(sortedByName: Bool) -> [TodoDocument]
  func readAll() -> Results<TodoDocument>
}

class TodoDocumentRepositoryImpl: TodoDocumentRepository {
  
  private var realm: Realm {
    get {
      print("realm 위치: ", Realm.Configuration.defaultConfiguration.fileURL!)
      return try! Realm()
    }
  }
  
  func create(
    item: TodoDocument
  ) {
    try? realm.write {
      realm.add(
        item
      )
    }
  }
  
  func addTodoItem(to document: TodoDocument, item: TodoItem) {
    try? realm.write {
      document.items.append(item)
    }
  }
  
  func removeTodoItem(from document: TodoDocument, item: TodoItem) {
    guard let index = document.items.index(of: item) else { return }
    try? realm.write {
      document.items.remove(at: index)
    }
  }
  
  func fetchAllDocuments(sortedByName: Bool) -> [TodoDocument] {
    let sortDescriptor = SortDescriptor(keyPath: "name", ascending: sortedByName)
    let documents = realm.objects(TodoDocument.self).sorted(by: [sortDescriptor])
    return Array(documents)
  }
  
  func readAll() -> Results<TodoDocument> {
    let documents = realm.objects(TodoDocument.self)
    return documents
  }
}
