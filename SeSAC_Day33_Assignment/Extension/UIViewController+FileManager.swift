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
    
    // "image/" 디렉토리 경로
    let imageDirectoryPath = documentDirectory.appendingPathComponent("image")
    
    // "image/" 디렉토리가 존재하는지 확인, 없다면 생성
    if !FileManager.default.fileExists(atPath: imageDirectoryPath.path) {
      do {
        try FileManager.default.createDirectory(at: imageDirectoryPath, withIntermediateDirectories: true, attributes: nil)
      } catch {
        print("image directory create error", error)
        return
      }
    }
    
    // 저장 파일 경로
    let fileURL = imageDirectoryPath.appendingPathComponent("\(filename).jpg")
    
    guard let data = image.jpegData(compressionQuality: 0.5) else { return }
    
    do {
      try data.write(to: fileURL)
    } catch {
      print("file save error", error)
    }
  }
  
  
  func loadImageFromDocument(filename: String) -> UIImage? {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return UIImage(systemName: "star.fill") }
    
    // 저장 파일 경로를 만들어줄거임.
    let imageDirectoryPath = documentDirectory.appendingPathComponent("image")
    let fileURL = imageDirectoryPath.appendingPathComponent("\(filename).jpg")
    
    // 경로에 파일이 있는지 확인
    
    print(fileURL.path())
    if FileManager.default.fileExists(atPath: fileURL.path()) {
      print("파일존재함")
      return UIImage(contentsOfFile: fileURL.path())
    } else {
      print("파일존재안함")
      return UIImage(systemName: "star.fill")
    }
  }
}
