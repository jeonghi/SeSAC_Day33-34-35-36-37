//
//  TodoRepository.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/18/24.
//

import Foundation
import RealmSwift

protocol TodoRepository {
  func create(todoItem: TodoItem) -> TodoItem?
  func readAll() -> Results<TodoItem>
  func readFiltered(by predicate: NSPredicate) -> Results<TodoItem>
  func searchByTitle(title: String) -> Results<TodoItem>
  func update(todoItem: TodoItem, with newTodoItem: TodoItem)
  func updateById(id: ObjectId, with: TodoItem)
  func readById(id: ObjectId) -> TodoItem?
  func delete(todoItem: TodoItem)
  func toggleDone(todoItem: TodoItem) -> TodoItem?
  func sortByDate(ascending: Bool) -> Results<TodoItem> // 날짜 기반 정렬
  func sortByTitle(ascending: Bool) -> Results<TodoItem> // 제목 기반 정렬
  func sortByPriority(ascending: Bool) -> Results<TodoItem> // 우선순위 기반 정렬
}

class TodoRepositoryImpl: TodoRepository {
  
  private var realm: Realm {
    get {
      //      print("realm 위치: ", Realm.Configuration.defaultConfiguration.fileURL!)
      return try! Realm()
    }
  }
  
  func toggleDone(todoItem: TodoItem) -> TodoItem? {
    do {
      try realm.write {
        todoItem.isDone = !todoItem.isDone
      }
      return todoItem // 정상적으로 추가되었으면 todoItem 반환
    } catch {
      return nil // 에러 발생시 nil 반환
    }
  }
  
  func updateById(id: ObjectId, with newTodoItem: TodoItem) {
  
    if let existingTodoItem = readById(id: id) {
      try? realm.write {
        existingTodoItem.title = newTodoItem.title
        existingTodoItem.memo = newTodoItem.memo
        existingTodoItem.dueDate = newTodoItem.dueDate
        existingTodoItem.tag = newTodoItem.tag
        existingTodoItem.priority = newTodoItem.priority
        existingTodoItem.isDone = newTodoItem.isDone
        existingTodoItem.imagePath = newTodoItem.imagePath
        existingTodoItem.timestamps?.updatedAt = Date()
      }
    }
  }
  
  func readById(id: ObjectId) -> TodoItem? {
    return realm.object(ofType: TodoItem.self, forPrimaryKey: id)
  }
  
  func create(todoItem: TodoItem) -> TodoItem? {
    do {
      try realm.write {
        realm.add(todoItem)
      }
      return todoItem // 정상적으로 추가되었으면 todoItem 반환
    } catch {
      return nil // 에러 발생시 nil 반환
    }
  }
  
  
  func readAll() -> Results<TodoItem> {
    return realm.objects(
      TodoItem.self
    )
  }
  
  func readFiltered(
    by predicate: NSPredicate
  ) -> Results<TodoItem> {
    return realm.objects(
      TodoItem.self
    ).filter(
      predicate
    )
  }
  
  func searchByTitle(
    title: String
  ) -> Results<TodoItem> {
    let predicate = NSPredicate(
      format: "title CONTAINS[c] %@",
      title
    )
    return realm.objects(
      TodoItem.self
    ).filter(
      predicate
    )
  }
  
  func update(
    todoItem: TodoItem,
    with newTodoItem: TodoItem
  ) {
    try! realm.write {
      todoItem.title = newTodoItem.title
      todoItem.memo = newTodoItem.memo
      todoItem.dueDate = newTodoItem.dueDate
      todoItem.priority = newTodoItem.priority
    }
  }
  
  func delete(
    todoItem: TodoItem
  ) {
    try! realm.write {
      realm.delete(
        todoItem
      )
    }
  }
  
  func sortByDate(
    ascending: Bool
  ) -> Results<TodoItem> {
    return realm.objects(
      TodoItem.self
    ).sorted(
      byKeyPath: "dueDate",
      ascending: ascending
    )
  }
  
  func sortByTitle(
    ascending: Bool
  ) -> Results<TodoItem> {
    return realm.objects(
      TodoItem.self
    ).sorted(
      byKeyPath: "title",
      ascending: ascending
    )
  }
  
  func sortByPriority(
    ascending: Bool
  ) -> Results<TodoItem> {
    return realm.objects(
      TodoItem.self
    ).sorted(
      byKeyPath: "priority",
      ascending: ascending
    )
  }
}

