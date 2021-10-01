//
//  ManagedFeedImage.swift
//  EssentialFeed
//
//  Created by Alex Tapia on 27/09/21.
//

import CoreData

@objc(ManagedFeedImage)
 class ManagedFeedImage: NSManagedObject {
  @NSManaged  var id: UUID
  @NSManaged  var imageDescription: String?
  @NSManaged  var location: String?
  @NSManaged  var url: URL
  @NSManaged  var cache: ManagedCache
}
 
extension ManagedFeedImage {
  
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
