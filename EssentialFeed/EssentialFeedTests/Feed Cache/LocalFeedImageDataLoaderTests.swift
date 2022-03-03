//
//  LocalFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Alex Tapia on 02/03/22.
//

import XCTest

final class LocalFeedImageDataLoader {
  init(store: Any) {
    
  }
}

class LocalFeedImageDataLoaderTests: XCTestCase {

  func test_init_doesNotMessageStoreUponCreation() {
    let (_, store) = makeSUT()
    
    XCTAssertTrue(store.receivedMessages.isEmpty)
  }
  
  // MARK: - Helpers
  
  private func makeSUT(currentDate: @escaping () -> Date = Date.init,
                       file: StaticString = #filePath,
                       line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: FeedStoreSpy) {
    let store = FeedStoreSpy()
    let sut = LocalFeedImageDataLoader(store: store)
    trackForMemoryLeaks(store, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return (sut, store)
  }
  
  private class FeedStoreSpy {
    var receivedMessages = [Any]()
  }
}
