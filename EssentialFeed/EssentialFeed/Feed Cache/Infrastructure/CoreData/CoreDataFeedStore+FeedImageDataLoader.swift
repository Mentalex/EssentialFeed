//
//  CoreDataFeedStore+FeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Alex Tapia on 29/05/22.
//

import Foundation

extension CoreDataFeedStore: FeedImageDataStore {
  
  public func insert(_ data: Data, for url: URL,
                     completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {
  }
  
  public func retrieve(dataForURL url: URL,
                       completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
    completion(.success(.none))
  }
}
