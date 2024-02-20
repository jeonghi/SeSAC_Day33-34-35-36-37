//
//  TodoDocument.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/21/24.
//

import RealmSwift
import Foundation

class TodoDocument: Object {
  
  @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate()
  @Persisted var name: String
  @Persisted var items: List<TodoItem> // to many 관계
  @Persisted var timestamps: Timestamps?
  
  convenience init(name: String) {
    self.init()
    self.name = name
    self.timestamps = .init()
  }
}

