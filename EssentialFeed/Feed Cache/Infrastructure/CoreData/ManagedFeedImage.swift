//
//  ManagedFeedImage.swift
//  EssentialFeed
//
//  Created by Alex Tapia on 27/09/21.
//

import CoreData

@objc(ManagedFeedImage)
internal class ManagedFeedImage: NSManagedObject {
  @NSManaged internal var id: UUID
  @NSManaged internal var imageDescription: String?
  @NSManaged internal var location: String?
  @NSManaged internal var url: URL
  @NSManaged internal var cache: ManagedCache
}
 
extension ManagedFeedImage {
  
  internal static func image(from localFeed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
    return NSOrderedSet(array: localFeed.map { local in
      let managed = ManagedFeedImage(context: context)
      managed.id = local.id
      managed.imageDescription = local.description
      managed.location = local.location
      managed.url = local.url
      return managed
    })
  }
  
  internal var local: LocalFeedImage {
    return LocalFeedImage(id: id, description: imageDescription, location: location, url: url)
  }
}
