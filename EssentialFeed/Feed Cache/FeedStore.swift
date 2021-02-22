//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Alex Tapia on 18/02/21.
//

import Foundation

public protocol FeedStore {
  
  typealias DeletionCompletion = (Error?) -> Void
  typealias InsertionCompletion = (Error?) -> Void
  typealias RetrievalCompletion = (Error?) -> Void
  
  func deleteCacheFeed(completion: @escaping DeletionCompletion)
  func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping DeletionCompletion)
  func retrieve(completion: @escaping RetrievalCompletion)
}
