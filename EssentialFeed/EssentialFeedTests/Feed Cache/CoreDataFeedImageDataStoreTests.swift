//
//  CoreDataFeedImageDataStoreTests.swift
//  EssentialFeedTests
//
//  Created by Alex Tapia on 28/05/22.
//

import XCTest
import EssentialFeed

extension CoreDataFeedStore: FeedImageDataStore {
  
  public func insert(_ data: Data, for url: URL,
                     completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {
  }
  
  public func retrieve(dataForURL url: URL,
                       completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
    completion(.success(.none))
  }
}

class CoreDataFeedImageDataStoreTests: XCTestCase {
  
  func test_retrieveImageData_deliversNotFoundWhenEmpty() {
    let sut = makeSUT()
    
    expect(sut, toCompleteRetrievalWith: notFound(), for: anyURL())
  }
  
  // - MARK: Helpers
  
  private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CoreDataFeedStore {
    let storeBundle = Bundle(for: CoreDataFeedStore.self)
    let storeURL = URL(fileURLWithPath: "/dev/null")
    let sut = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
    trackForMemoryLeaks(sut, file: file, line: line)
    return sut
  }
  
  private func notFound() -> FeedImageDataStore.RetrievalResult {
    return .success(.none)
  }
  
  private func expect(_ sut: CoreDataFeedStore,
                      toCompleteRetrievalWith expectedResult: FeedImageDataStore.RetrievalResult,
                      for url: URL,
                      file: StaticString = #filePath,
                      line: UInt = #line) {
    let exp = expectation(description: "Wait for load completion")
    sut.retrieve(dataForURL: url) { recievedResult in
      switch (recievedResult, expectedResult) {
      case let (.success(receivedData), .success(expectedData)):
        XCTAssertEqual(receivedData, expectedData, file: file, line: line)
        
      default:
        XCTFail("Expected \(expectedResult), got \(recievedResult) instead", file: file, line: line)
      }
      exp.fulfill()
    }
    wait(for: [exp], timeout: 1.0)
  }
}

