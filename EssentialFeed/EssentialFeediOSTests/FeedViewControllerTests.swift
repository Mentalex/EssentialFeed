//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Alex Tapia on 02/10/21.
//

import XCTest

final class FeedViewController {
  init(loader: FeedViewControllerTests.LoaderSpy) {
  }
}

final class FeedViewControllerTests: XCTestCase {
  
  func test_init_doestNotLoadFeed() {
    let loader = LoaderSpy()
    _ = FeedViewController(loader: loader)
    
    XCTAssertEqual(loader.loadCallCount, 0)
  }
  
  // MARK: - Helpers
  
  class LoaderSpy {
    private(set) var loadCallCount: Int = 0
  }
}

