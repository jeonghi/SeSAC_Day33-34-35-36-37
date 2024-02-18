//
//  PlaceholderTextView.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/18/24.
//

import UIKit

final class PlaceholderTextView: UITextView {
  
  private let placeholderTextView: UITextView = {
    let view = UITextView()
    view.backgroundColor = .clear
    view.textColor = UIColor(red: 0, green: 0, blue: 0.098, alpha: 0.22)
    view.isUserInteractionEnabled = false
    view.isAccessibilityElement = false
    return view
  }()
  
  init() {
    super.init(frame: .zero, textContainer: nil)
    setupUI()
  }
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("\(#function) has not been implemented")
  }
  
  func setupUI() {
    delegate = self
    
//    backgroundColor = .lightGray.withAlphaComponent(0.3)
    
    layer.cornerRadius = 14.0
    clipsToBounds = true
    
//    textContainerInset = UIEdgeInsets(top: 30, left: 24, bottom: 30, right: 24)
    contentInset = .zero
    
    addSubview(placeholderTextView)
    
//    placeholderTextView.textContainerInset = UIEdgeInsets(top: 30, left: 24, bottom: 30, right: 24)
    placeholderTextView.contentInset = contentInset
  }
  
  var placeholderText: String? {
    didSet {
      placeholderTextView.text = placeholderText
      updatePlaceholderTextView() // <-
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    updatePlaceholderTextView() // <-
  }
  
  func updatePlaceholderTextView() {
    placeholderTextView.isHidden = !text.isEmpty
    accessibilityValue = text.isEmpty ? placeholderText ?? "" : text
    
    placeholderTextView.textContainer.exclusionPaths = textContainer.exclusionPaths
    placeholderTextView.textContainer.lineFragmentPadding = textContainer.lineFragmentPadding
    placeholderTextView.frame = bounds
  }
}

extension PlaceholderTextView: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    updatePlaceholderTextView() // <-
  }
}
