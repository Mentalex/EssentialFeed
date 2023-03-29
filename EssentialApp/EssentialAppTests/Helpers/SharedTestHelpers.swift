//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Alex Tapia on 21/11/22.
//

import Foundation
import EssentialFeed

func anyNSError() -> NSError {
  return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
  return URL(string: "http://a-url.com")!
}

func anyData() -> Data {
  return Data("any data".utf8)
}

func uniqueFeed() -> [FeedImage] {
  return [FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())]
}
