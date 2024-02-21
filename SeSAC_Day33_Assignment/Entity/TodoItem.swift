//
//  Todo.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import RealmSwift
import Foundation

class TodoItem: Object {
  
  @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate()
  @Persisted var title: String
  @Persisted var memo: String?
  @Persisted var dueDate: Date?
  @Persisted var tag: String?
  @Persisted var priority: Priority?
  @Persisted var isDone: Bool
  @Persisted var imagePath: String?
  @Persisted(originProperty: "items") var document: LinkingObjects<TodoDocument> // Inverse 관계
  @Persisted var timestamps: Timestamps?
  
  convenience init(title: String, memo: String? = nil, dueDate: Date? = nil, tag: String? = nil, priority: Priority? = nil, imagePath: String? = nil) {
    self.init()
    self.title = title
    self.memo = memo
    self.dueDate = dueDate
    self.tag = tag
    self.priority = priority
    self.isDone = false
    self.timestamps = Timestamps()
    self.imagePath = imagePath
  }
  
  // 복사 생성자
  convenience init(copy from: TodoItem) {
    self.init()
    self.title = from.title
    self.memo = from.memo
    self.dueDate = from.dueDate
    self.tag = from.tag
    self.priority = from.priority
    self.isDone = from.isDone
    self.imagePath = from.imagePath
    self.timestamps = from.timestamps
  }
  
  enum SortOption: String, CaseIterable {
    case createDate = "생성날짜"
    case dueDate = "마감일"
    case priority = "우선순위"
    case title = "제목"
    
    var keyPath: String {
      switch self {
      case .createDate:
        return "timestamps.createdAt"
      case .dueDate:
        return "dueDate"
      case .priority:
        return "priority"
      case .title:
        return "title"
      }
    }
  }
}



