//
//  AppDelegate.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/14/24.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // Realm 마이그레이션 설정
    let config = Realm.Configuration(
      schemaVersion: 1, // 이전 버전보다 높은 숫자 사용
      migrationBlock: { migration, oldSchemaVersion in
        if (oldSchemaVersion < 1) {
          // 필요한 경우 여기에서 추가 마이그레이션 로직을 구현
        }
      })
    
    Realm.Configuration.defaultConfiguration = config
    
    do {
      _ = try Realm() // Realm을 열 때 마이그레이션 설정이 적용됩니다.
    } catch {
      print("Realm opening or migration failed: \(error)") // 마이그레이션 에러 처리
    }
    
    return true
  }
  
  // MARK: UISceneSession Lifecycle
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
  
  
}

