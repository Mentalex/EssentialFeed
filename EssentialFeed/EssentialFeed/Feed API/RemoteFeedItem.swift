//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Alex Tapia on 21/02/21.
//

import Foundation

 struct RemoteFeedItem: Decodable {
   let id: UUID
   let description: String?
   let location: String?
   let image: URL
}
