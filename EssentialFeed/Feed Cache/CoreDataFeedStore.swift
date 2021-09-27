//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Alex Tapia on 26/09/21.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
  
  public init() {}
  
  public func retrieve(completion: @escaping RetrievalCompletion) {
    completion(.empty)
  }
  
  public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping DeletionCompletion) {
    
  }
  
  public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
  }

}

private class ManagedCache: NSManagedObject {
  @NSManaged var timestamp: Date
  @NSManaged var feed: NSOrderedSet
}

private class ManagedFeedImage: NSManagedObject {
  @NSManaged var id: UUID
  @NSManaged var imageDescription: String?
  @NSManaged var location: String?
  @NSManaged var url: URL
  @NSManaged var cache: ManagedCache
}
