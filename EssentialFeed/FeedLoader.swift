//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Alex Tapia on 19/12/20.
//

import Foundation

enum LoadFeedResult {
  case success([FeedItem])
  case error(Error)
}

protocol FeedLoader {
  func load(completion: @escaping (LoadFeedResult) -> Void)
}
