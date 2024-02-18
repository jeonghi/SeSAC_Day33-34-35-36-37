//
//  UITableViewCell+Extension.swift
//  SeSAC_Day33_Assignment
//
//  Created by 쩡화니 on 2/18/24.
//

import UIKit

extension UITableViewCell {
  var tableView: UITableView? {
    var view = superview
    while view != nil && !(view is UITableView) {
      view = view?.superview
    }
    return view as? UITableView
  }
}

