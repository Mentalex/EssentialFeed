//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Alex Tapia on 26/09/21.
//

import CoreData

public final class CoreDataFeedStore: FeedStore {
  
  private let container: NSPersistentContainer
  private let context: NSManagedObjectContext
  
  public init(storeURL: URL, bundle: Bundle = .main) throws {
    container = try NSPersistentContainer.load(modelName: "FeedStore", url: storeURL, in: bundle)
    context = container.newBackgroundContext()
  }
  
  public func retrieve(completion: @escaping RetrievalCompletion) {
    let context = self.context
    context.perform {
      do {
        let request = NSFetchRequest<ManagedCache>(entityName: ManagedCache.entity().name!)
        request.returnsObjectsAsFaults = false
        if let cache = try context.fetch(request).first {
          completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
        } else {
          completion(.empty)
        }
      } catch {
        completion(.failure(error))
      }
    }
  }
  
  public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping DeletionCompletion) {
    let context = self.context
    context.perform {
      do {
        let managedCache = ManagedCache(context: context)
        managedCache.timestamp = timestamp
        managedCache.feed = ManagedFeedImage.image(from: feed, in: context)
        
        try context.save()
        completion(nil)
      } catch {
        completion(error)
      }
    }
  }
  
  public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
  }
}

private extension NSPersistentContainer {
  
  enum LoadingError: Error {
    case modelNotFound
    case failedToLoadPersistentStores(Error)
  }
  
  static func load(modelName name: String, url: URL, in bundle: Bundle) throws -> NSPersistentContainer {
    guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
      throw LoadingError.modelNotFound
    }
    
    let description = NSPersistentStoreDescription(url: url)
    let container = NSPersistentContainer(name: name, managedObjectModel: model)
    container.persistentStoreDescriptions = [description]
    
    var loadError: Error?
    container.loadPersistentStores { loadError = $1 }
    try loadError.map { throw LoadingError.failedToLoadPersistentStores($0) }
    
    return container
  }
}

private extension NSManagedObjectModel {
  static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
    return bundle
      .url(forResource: name, withExtension: "momd")
      .flatMap { NSManagedObjectModel(contentsOf: $0) }
  }
}

@objc(ManagedCache)
private class ManagedCache: NSManagedObject {
  
  @NSManaged var timestamp: Date
  @NSManaged var feed: NSOrderedSet
  
  var localFeed: [LocalFeedImage] {
    return feed.compactMap { ($0 as? ManagedFeedImage)?.local }
  }
}

@objc(ManagedFeedImage)
private class ManagedFeedImage: NSManagedObject {
  
  @NSManaged var id: UUID
  @NSManaged var imageDescription: String?
  @NSManaged var location: String?
  @NSManaged var url: URL
  @NSManaged var cache: ManagedCache
  
  static func image(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
    return NSOrderedSet(array: localFeed.map { local in
      let managed = ManagedFeedImage(context: context)
      managed.id = local.id
      managed.imageDescription = local.description
      managed.location = local.location
      managed.url = local.url
      return managed
    })
  }
  
  var local: LocalFeedImage {
    return LocalFeedImage(id: id, description: imageDescription, location: location, url: url)
  }
}
