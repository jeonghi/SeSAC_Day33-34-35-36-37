//
//  NotificationManager.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import Foundation

extension Notification.Name {
  static let didReceiveData = Notification.Name("didReceiveData")
}

// NotificationManager 클래스 정의
class NotificationManager {
  
  static let shared = NotificationManager()
  
  private init() {}
  
  /// 데이터를 전달하는 알림을 보내는 메서드
  func post(data: Any, notification: Notification.Name) {
    NotificationCenter.default.post(name: notification, object: nil, userInfo: ["data": data])
  }
  
  /// 알림을 받는 리스너를 등록하는 메서드
  func addObserver(observer: Any, selector: Selector, notification: Notification.Name) {
    NotificationCenter.default.addObserver(observer, selector: selector, name: notification, object: nil)
  }
  
  /// 알림 리스너를 제거하는 메서드
  func removeObserver(observer: Any, notification: Notification.Name) {
    NotificationCenter.default.removeObserver(observer, name: notification, object: nil)
  }
}
