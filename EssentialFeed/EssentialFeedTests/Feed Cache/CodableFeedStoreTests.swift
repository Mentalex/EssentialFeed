//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Alex Tapia on 05/09/21.
//

import XCTest
import EssentialFeed

class CodableFeedStoreTests: XCTestCase, FailableFeedStore {
  
  override func setUp() {
    super.setUp()

    setupEmptyStoreState()
  }
  
  override func tearDown() {
    super.tearDown()

    undoStoreSideEffects()
  }
  
  func test_retrieve_deliversEmptyOnEmptyCache() {
    let sut = makeSUT()
    
    assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
  }
  
  func test_retrieve_hasNoSideEffectsOnEmptyCache() {
    let sut = makeSUT()
    
    assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
  }
  
  func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
    #if os(OSX)
    let sut = makeSUT()
    
    assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
    #endif
  }
  
  func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
    #if os(OSX)
    let sut = makeSUT()
    
    assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
    #endif
  }
  
  func test_retrieve_deliversFailureOnRetrievalError() {
    #if os(OSX)
    let storeURL = testSpecificStoreURL()
    let sut = makeSUT(storeURL: storeURL)
    
    try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
    
    assertThatRetrieveDeliversFailureOnRetrievalError(on: sut)
    #endif
  }

  func test_retrieve_hasNoSideEffectsOnFailure() {
    #if os(OSX)
    let storeURL = testSpecificStoreURL()
    let sut = makeSUT(storeURL: storeURL)
    
    try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
    
    assertThatRetrieveHasNoSideEffectsOnFailure(on: sut)
    #endif
  }
  
  func test_insert_deliversNoErrorOnEmptyCache() {
    #if os(OSX)
    let sut = makeSUT()
    
    assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
    #endif
  }
  
  func test_insert_deliversNoErrorOnNonEmptyCache() {
    #if os(OSX)
    let sut = makeSUT()
    
    assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
    #endif
  }
  
  func test_insert_overridesPreviouslyInsertedCacheValues() {
    #if os(OSX)
    let sut = makeSUT()
    
    assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
    #endif
  }
  
  func test_insert_deliversErrorOnInsertionError() {
    let invalidStoreURL = URL(string: "invalid://store-url")!
    let sut = makeSUT(storeURL: invalidStoreURL)
    
    assertThatInsertDeliversErrorOnInsertionError(on: sut)
  }
  
  func test_insert_hasNoSideEffectsOnInsertionError() {
    let invalidStoreURL = URL(string: "invalid://store-url")!
    let sut = makeSUT(storeURL: invalidStoreURL)
    
    assertThatInsertHasNoSideEffectsOnInsertionError(on: sut)
  }
  
  func test_delete_deliversNoErrorOnEmptyCache() {
    let sut = makeSUT()
    
    assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
  }
  
  func test_delete_hasNoSideEffectsOnEmptyCache() {
    let sut = makeSUT()
    
    assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
  }
  
  func test_delete_deliversNoErrorOnNonEmptyCache() {
    let sut = makeSUT()
    
    assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
  }
  
  func test_delete_emptiesPreviouslyInsertedCache() {
    let sut = makeSUT()
    
    assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
  }
  
  func test_delete_deliversErrorOnDeletionError() {
    #if os(OSX)
    let noDeletePermissionURL = cachesDirectory()
    let sut = makeSUT(storeURL: noDeletePermissionURL)
      
    assertThatDeleteDeliversErrorOnDeletionError(on: sut)
    #endif
  }
  
  func test_delete_hasNoSideEffectsOnDeletionError() {
    let noDeletePermissionURL = cachesDirectory()
    let sut = makeSUT(storeURL: noDeletePermissionURL)
    
    assertThatDeleteHasNoSideEffectsOnDeletionError(on: sut)
  }
  
  func test_storeSideEffects_runSerially() {
    let sut = makeSUT()
    
    assertThatSideEffectsRunSerially(on: sut)
  }
  
  // MARK: - Helpers

  private func makeSUT(storeURL: URL? = nil, file: StaticString = #filePath, line: UInt = #line) -> FeedStore {
    let sut = CodableFeedStore(storeURL: storeURL ?? testSpecificStoreURL())
    trackForMemoryLeaks(sut, file: file, line: line)
    return sut
  }
  
  private func setupEmptyStoreState() {
    deleteStoreArtifacts()
  }
  
  private func undoStoreSideEffects() {
    deleteStoreArtifacts()
  }
  
  private func deleteStoreArtifacts() {
    try? FileManager.default.removeItem(at: testSpecificStoreURL())
  }
  
  private func testSpecificStoreURL() -> URL {
    return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
  }
  
  private func cachesDirectory() -> URL {
    return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
  }
}
