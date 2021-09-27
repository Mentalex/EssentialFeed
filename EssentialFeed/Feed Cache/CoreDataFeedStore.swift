//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Alex Tapia on 26/09/21.
//

import Foundation

public class CoreDataFeedStore: FeedStore {
  
  public init() {}
  
  public func retrieve(completion: @escaping RetrievalCompletion) {
    completion(.empty)
  }
  
  public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping DeletionCompletion) {
    
  }
  
  public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
  }
  
}
