//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Alex Tapia on 11/10/21.
//

import UIKit
import EssentialFeed

final class FeedRefreshViewController: NSObject {
  
  private(set) lazy var view: UIRefreshControl = {
    let view = UIRefreshControl()
    view.addTarget(self, action: #selector(refresh) , for: .valueChanged)
    return view
  }()
  
  private let feedLoader: FeedLoader
  
  init(feedLoader: FeedLoader) {
    self.feedLoader = feedLoader
  }
  
  var onRefresh: (([FeedImage]) -> Void)?
  
  @objc func refresh() {
    view.beginRefreshing()
    feedLoader.load { [weak self] result in
      if let feed = try? result.get() {
        self?.onRefresh?(feed)
      }
      self?.view.endRefreshing()
    }
  }
}
