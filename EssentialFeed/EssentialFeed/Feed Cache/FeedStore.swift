//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Alex Tapia on 18/02/21.
//

import Foundation

public typealias CacheFeed = (feed: [LocalFeedImage], timestamp: Date)

public protocol FeedStore {
  typealias DeletionResult = Result<Void,Error>
  typealias DeletionCompletion = (DeletionResult) -> Void
  
  typealias InsertionResult = Result<Void,Error>
  typealias InsertionCompletion = (InsertionResult) -> Void
  
  typealias RetrievalResult = Result<CacheFeed?,Error>
  typealias RetrievalCompletion = (RetrievalResult) -> Void
  
  /// The completion handler can be invoked in any thread.
  /// Clients are responsible to dispatch to appropriate threads, if needed.
  func deleteCachedFeed(completion: @escaping DeletionCompletion)
  
  /// The completion handler can be invoked in any thread.
  /// Clients are responsible to dispatch to appropriate threads, if needed.
  func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping DeletionCompletion)
  
  /// The completion handler can be invoked in any thread.
  /// Clients are responsible to dispatch to appropriate threads, if needed.
  func retrieve(completion: @escaping RetrievalCompletion)
}
