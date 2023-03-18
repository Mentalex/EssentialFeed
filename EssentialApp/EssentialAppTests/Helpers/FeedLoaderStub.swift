//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Alex Tapia on 18/03/23.
//

import Foundation
import EssentialFeed

class FeedLoaderStub: FeedLoader {
  private let result: FeedLoader.Result
  
  init(result: FeedLoader.Result) {
    self.result = result
  }
  
  func load(completion: @escaping (FeedLoader.Result) -> Void) {
    completion(result)
  }
}
