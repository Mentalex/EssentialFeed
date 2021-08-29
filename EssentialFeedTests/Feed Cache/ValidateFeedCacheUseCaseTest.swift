//
//  ValidateFeedCacheUseCaseTest.swift
//  EssentialFeedTests
//
//  Created by Alex Tapia on 29/08/21.
//

import XCTest
import EssentialFeed

class ValidateFeedCacheUseCaseTest: XCTestCase {
  
  func test_init_doesNotMessagesStoreUponCreation() {
    let (_, store) = makeSUT()
    
    XCTAssertEqual(store.receivedMessages, [])
  }
  
  // MARK: - Helpers

  private func makeSUT(currentDate: @escaping () -> Date = Date.init,
                       file: StaticString = #filePath,
                       line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
    let store = FeedStoreSpy()
    let sut = LocalFeedLoader(store: store, currentDate: currentDate)
    trackForMemoryLeaks(store, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return (sut, store)
  }
}