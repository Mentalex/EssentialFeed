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
  
  func deleteCacheFeed(completion: @escaping DeletionCompletion)
  func insert(_ items: [LocalFeedItem], timestamp: Date, completion: @escaping DeletionCompletion)
}

public struct LocalFeedItem: Equatable {
  
  public let id: UUID
  public let description: String?
  public let location: String?
  public let imageURL: URL
  
  public init(id: UUID, description: String?, location: String?, imageURL: URL) {
    self.id = id
    self.description = description
    self.location = location
    self.imageURL = imageURL
  }
}
