//
//  UIRefreshControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Alex Tapia on 10/10/21.
//

import UIKit

extension UIRefreshControl {
  func simulatePullToRefresh() {
    allTargets.forEach { target in
      actions(forTarget: target, forControlEvent: .valueChanged)?
        .forEach { (target as NSObject).perform(Selector($0)) }
    }
  }
}
