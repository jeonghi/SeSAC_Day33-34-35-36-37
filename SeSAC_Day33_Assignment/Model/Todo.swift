//
//  Todo.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import RealmSwift
import Foundation

class TodoEntity: Object {
  @Persisted(primaryKey: true) var _id: ObjectId
  @Persisted var title: String?
  @Persisted var content: String?
  @Persisted var tag: String?
  @Persisted var priority: Priority = .one
  @Persisted var deadline: Date
  @Persisted var createdAt: Date
  @Persisted var updatedAt: Date

  convenience init(title: String? = nil, content: String? = nil, tag: String? = nil, priority: Priority, deadline: Date = Date(), createdAt: Date = Date(), updatedAt: Date = Date()) {
    self.init()
    self.title = title
    self.content = content
    self.tag = tag
    self.priority = priority
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}

class TodoModel {
  var title: String?
  var content: String?
  var tag: String?
  var priority: Priority
  var deadline: Date
  var createdAt: Date
  var updatedAt: Date
  
  init(title: String? = nil, content: String? = nil, tag: String? = nil, priority: Priority = .one, deadline: Date = Date(), createdAt: Date = Date(), updatedAt: Date = Date()) {
    self.title = title
    self.content = content
    self.tag = tag
    self.priority = priority
    self.deadline = deadline
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}
 
