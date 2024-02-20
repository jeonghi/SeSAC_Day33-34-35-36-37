//
//  Timestapms.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/21/24.
//

import Foundation
import RealmSwift

class Timestamps: EmbeddedObject {
  @Persisted var createdAt: Date
  @Persisted var updatedAt: Date?
  
  convenience init(createdAt: Date = Date(), updatedAt: Date? = Date()) {
    self.init()
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}
