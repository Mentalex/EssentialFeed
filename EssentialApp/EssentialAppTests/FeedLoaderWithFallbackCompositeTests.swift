//
//  FeedLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Alex Tapia on 21/08/22.
//

import XCTest
import EssentialFeed
import EssentialApp

class FeedLoaderWithFallbackCompositeTests: XCTestCase, FeedLoaderTestCase {

  func test_load_deliversPrimaryFeedOnPrimarySuccess() {
    let primaryFeed = uniqueFeed()
    let fallbackFeed = uniqueFeed()
    let sut = makeSUT(primaryResult: .success(primaryFeed), fallbackResult: .success(fallbackFeed))
    
    expect(sut, toCompleteWith: .success(primaryFeed))
  }
  
  func test_load_deliversFallbackFeedOnPrimaryFailure() {
    let fallbackFeed = uniqueFeed()
    let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .success(fallbackFeed))
    
    expect(sut, toCompleteWith: .success(fallbackFeed))
  }
  
  func test_load_deliversErrorOnBothPrimaryAndFallbackLoaderFailure() {
    let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .failure(anyNSError()))
    
    expect(sut, toCompleteWith: .failure(anyNSError()))
  }
  
  // MARK: - Helpers
  
  private func makeSUT(primaryResult: FeedLoader.Result,
                       fallbackResult: FeedLoader.Result,
                       file: StaticString = #filePath,
                       line: UInt = #line) -> FeedLoader {
    let primaryLoader = FeedLoaderStub(result: primaryResult)
    let fallbackLoader = FeedLoaderStub(result: fallbackResult)
    let sut = FeedLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
    trackForMemoryLeaks(primaryLoader, file: file, line: line)
    trackForMemoryLeaks(fallbackLoader, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return sut
  }
}
