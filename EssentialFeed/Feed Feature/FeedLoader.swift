//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Alex Tapia on 19/12/20.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedImage], Error>

public protocol FeedLoader {
  func load(completion: @escaping (LoadFeedResult) -> Void)
}
