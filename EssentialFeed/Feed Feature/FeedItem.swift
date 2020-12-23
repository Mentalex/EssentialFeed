//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Alex Tapia on 19/12/20.
//

import Foundation

public struct FeedItem: Equatable {
  let id: UUID
  let description: String?
  let location: String?
  let imageURL: URL
}
