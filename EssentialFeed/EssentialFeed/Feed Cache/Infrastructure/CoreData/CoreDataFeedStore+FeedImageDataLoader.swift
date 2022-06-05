//
//  CoreDataFeedStore+FeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Alex Tapia on 29/05/22.
//

import Foundation
import CoreData

extension CoreDataFeedStore: FeedImageDataStore {
  
  public func insert(_ data: Data, for url: URL,
                     completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {
    perform { context in
      completion(Result {
        let image = try ManagedFeedImage.first(with: url, in: context)
        image?.data = data
        try context.save()
      })
    }
  }
  
  public func retrieve(dataForURL url: URL,
                       completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
    perform { context in
      completion(Result {
        try ManagedFeedImage.first(with: url, in: context)?.data
      })
    }
  }
}
