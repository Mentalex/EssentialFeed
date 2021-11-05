//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Alex Tapia on 04/11/21.
//

import UIKit

extension UIRefreshControl {
  func update(isRefreshing: Bool) {
    isRefreshing ? beginRefreshing() : endRefreshing()
  }
}


