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
  
  func test_validateCache_deletesCacheOnRetrievalError() {
    let (sut, store) = makeSUT()
    
    sut.validateCache()
    store.completeRetrieval(with: anyNSError())
    
    XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
  }
  
  func test_validateCache_doesNotDeleteCacheOnEmptyCache() {
    let (sut, store) = makeSUT()
    
    sut.validateCache()
    store.completeRetrievalWithEmtyCache()
    
    XCTAssertEqual(store.receivedMessages, [.retrieve])
  }
  
  func test_validateCache_doesNotDeleteNonExpiredCache() {
    let feed = uniqueImageFeed()
    let fixedCurrentDate = Date()
    let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
    let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
    
    sut.validateCache()
    store.completeRetrieval(with: feed.local, timestamp: nonExpiredTimestamp)
    
    XCTAssertEqual(store.receivedMessages, [.retrieve])
  }
  
  func test_validateCache_deletesCacheOnExpiration() {
    let feed = uniqueImageFeed()
    let fixedCurrentDate = Date()
    let expirationTimestamp = fixedCurrentDate.minusFeedCacheMaxAge()
    let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
    
    sut.validateCache()
    store.completeRetrieval(with: feed.local, timestamp: expirationTimestamp)
    
    XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
  }
  
  func test_validateCache_deletesExpiredCache() {
    let feed = uniqueImageFeed()
    let fixedCurrentDate = Date()
    let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
    let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
    
    sut.validateCache()
    store.completeRetrieval(with: feed.local, timestamp: expiredTimestamp)
    
    XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
  }
  
  func test_validateCache_doesNotDeleteInvalidCacheAfterSUTInstanceHasBeenDeallocated() {
    let store = FeedStoreSpy()
    var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
    
    sut?.validateCache()
    
    sut = nil
    store.completeRetrieval(with: anyNSError())
    
    XCTAssertEqual(store.receivedMessages, [.retrieve])
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
