//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Alex Tapia on 17/04/22.
//

import Foundation

public protocol FeedImageDataStore {
  
  typealias Result = Swift.Result<Data?, Error>
  
  func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
