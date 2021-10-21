//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Alex Tapia on 18/10/21.
//

import EssentialFeed

protocol FeedLoadingView: AnyObject {
  func display(isLoading: Bool)
}

protocol FeedView {
  func display(feed: [FeedImage])
}

final class FeedPresenter {
  
  private let feedLoader: FeedLoader
  
  init(feedLoader: FeedLoader) {
    self.feedLoader = feedLoader
  }
  
  var feedView: FeedView?
  weak var loadingView: FeedLoadingView?
  
  func loadFeed() {
    loadingView?.display(isLoading: true)
    feedLoader.load { [weak self] result in
      if let feed = try? result.get() {
        self?.feedView?.display(feed: feed)
      }
      self?.loadingView?.display(isLoading: false)
    }
  }
}
