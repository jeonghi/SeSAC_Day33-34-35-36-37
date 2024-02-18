//
//  Date+Extension.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/19/24.
//

import Foundation

extension Date {
  func toString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy. MM. dd"
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone.current
    return formatter.string(from: self)
  }
}
