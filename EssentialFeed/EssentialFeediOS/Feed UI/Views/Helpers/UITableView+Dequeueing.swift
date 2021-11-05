//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Alex Tapia on 23/10/21.
//

import UIKit

extension UITableView {
  
  func dequeueReusableCell<T: UITableViewCell>() -> T {
    let identifier = String(describing: T.self)
    return dequeueReusableCell(withIdentifier: identifier) as! T
  }
}
