//
//  Note.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/18/24.
//

import Foundation

final class Note {
  init(
    topic: String,
    text: String
  ) {
    self.topic = topic
    self.text = text
  }
  
  var topic: String = "" {
    didSet {
      print(
        "Topic changed to \(topic)."
      )
    }
  }
  
  var text: String = "" {
    didSet {
      print(
        "Text changed to \(text)."
      )
    }
  }
}
