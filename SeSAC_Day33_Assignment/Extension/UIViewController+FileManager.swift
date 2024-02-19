//
//  UIViewController+FileManager.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/19/24.
//

import UIKit

extension UIViewController {
  func saveImageToDocument(image: UIImage, filename: String) {
    // 앱의 도큐먼트 위치
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    
    // 저장 파일 경로를 만들어줄거임.
    let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
    
    guard let data = image.jpegData(compressionQuality: 0.5) else { return }
    
    do {
      try data.write(to: fileURL)
    } catch {
      
    }
  }
  
  func loadImageToDocument(filename: String) -> UIImage? {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
    
    // 저장 파일 경로를 만들어줄거임.
    let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
    
    // 경로에 파일이 있는지 확인
    
    if FileManager.default.fileExists(atPath: fileURL.path()) {
      return UIImage(contentsOfFile: fileURL.path())
    } else {
      return UIImage(systemName: "stat.fill")
    }
  }
}
