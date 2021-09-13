//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Alex Tapia on 05/09/21.
//

import XCTest
import EssentialFeed

class CodableFeedStore {
  
  private struct Cache: Codable {
    let feed: [CodableFeedImage]
    let timestamp: Date
    
    var localFeed: [LocalFeedImage] {
      return feed.map { $0.local }
    }
  }
  
  private struct CodableFeedImage: Codable {
    private let id: UUID
    private let description: String?
    private let location: String?
    private let url: URL
    
    init(_ image: LocalFeedImage) {
      id = image.id
      description = image.description
      location = image.location
      url = image.url
    }
    
    var local: LocalFeedImage {
      return LocalFeedImage(id: id, description: description, location: location, url: url)
    }
  }
  
  private let storeURL: URL
  
  init(storeURL: URL) {
    self.storeURL = storeURL
  }
  
  func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
    guard let data = try? Data(contentsOf: storeURL) else {
      return completion(.empty)
    }
    
    let decoder = JSONDecoder()
    let cache = try! decoder.decode(Cache.self, from: data)
    completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
  }
  
  func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping FeedStore.DeletionCompletion) {
    let encoder = JSONEncoder()
    let cache = Cache(feed: feed.map(CodableFeedImage.init), timestamp: timestamp)
    let encoded = try! encoder.encode(cache)
    try! encoded.write(to: storeURL)
    completion(nil)
  }
}

class CodableFeedStoreTests: XCTestCase {
  
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
    
    expect(sut, toRetrive: .empty)
  }
  
  func test_retrieve_hasNoSideEffectsOnEmptyCache() {
    let sut = makeSUT()
    
    expect(sut, toRetriveTwice: .empty)
  }
  
  func test_retrieveAfterInsertingToEmptyCache_deliversInsertedValues() {
    let sut = makeSUT()
    let feed = uniqueImageFeed().local
    let timestamp = Date()
    
    let exp = expectation(description: "Wait for cache retrieval")
    sut.insert(feed, timestamp: timestamp) { insertionError in
      XCTAssertNil(insertionError, "Expected feed to be inserted successfully")
      exp.fulfill()
    }
    wait(for: [exp], timeout: 1.0)
    
    expect(sut, toRetrive: .found(feed: feed, timestamp: timestamp))
  }
  
  func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
    let sut = makeSUT()
    let feed = uniqueImageFeed().local
    let timestamp = Date()
    
    let exp = expectation(description: "Wait for cache insertion")
    sut.insert(feed, timestamp: timestamp) { insertionError in
      XCTAssertNil(insertionError, "Expected feed to be inserted successfully")
      exp.fulfill()
    }
    wait(for: [exp], timeout: 1.0)
    
    expect(sut, toRetriveTwice: .found(feed: feed, timestamp: timestamp))
  }
  
  // MARK: - Helpers

  private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CodableFeedStore {
    let sut = CodableFeedStore(storeURL: testSpecificStoreURL())
    trackForMemoryLeaks(sut, file: file, line: line)
    return sut
  }
  
  private func expect(_ sut: CodableFeedStore, toRetriveTwice expectedResult: RetrieveCachedFeedResult, file: StaticString = #filePath, line: UInt = #line) {
    expect(sut, toRetrive: expectedResult, file: file, line: line)
    expect(sut, toRetrive: expectedResult, file: file, line: line)
  }
  
  private func expect(_ sut: CodableFeedStore, toRetrive expectedResult: RetrieveCachedFeedResult, file: StaticString = #filePath, line: UInt = #line) {
    let exp = expectation(description: "Wait for cache retrieval")
    
    sut.retrieve { retrievedResult in
      switch (expectedResult, retrievedResult) {
      case (.empty, .empty):
        break
        
      case let (.found(expectedFeed, expectedTimestamp), .found(retrievedFeed, retrievedTimestamp)):
        XCTAssertEqual(retrievedFeed, expectedFeed, file: file, line: line)
        XCTAssertEqual(retrievedTimestamp, expectedTimestamp, file: file, line: line)
        
      default:
        XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
      }
      
      exp.fulfill()
    }
    
    wait(for: [exp], timeout: 1.0)
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
    return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
  }
}
