//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Alex Tapia on 19/12/20.
//

import Foundation

public enum LoadFeedResult {
  case success([FeedItem])
  case failure(Error)
}

protocol FeedLoader {
  func load(completion: @escaping (LoadFeedResult) -> Void)
}
