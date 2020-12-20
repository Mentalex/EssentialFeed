//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Alex Tapia on 19/12/20.
//

import XCTest

class RemoteFeedLoader {
}

class HTTPClient {
  var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {
  
  func test_init() {
    let client = HTTPClient()
    _ = RemoteFeedLoader()
    
    XCTAssertNil(client.requestedURL)
  }
}
