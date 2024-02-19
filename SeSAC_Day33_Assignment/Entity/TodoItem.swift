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
  @Persisted var priority: Priority? // 우선순위를 Priority enum으로 변경
  @Persisted var isDone: Bool
  @Persisted var createdAt: Date
  @Persisted var updatedAt: Date?
  
  convenience init(title: String, memo: String? = nil, dueDate: Date? = nil, tag: String? = nil, priority: Priority? = nil) {
    self.init()
    self.title = title
    self.memo = memo
    self.dueDate = dueDate
    self.tag = tag
    self.priority = priority
    self.isDone = false
    self.createdAt = Date() // 현재 시간으로 초기화
    self.updatedAt = Date() // 현재 시간으로 초기화
  }
}
