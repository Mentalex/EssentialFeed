//
//  XCTestCase+FailableRetrieveFeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Alex Tapia on 23/09/21.
//

import XCTest
import EssentialFeed

extension FailableRetrieveFeedStoreSpecs where Self: XCTestCase {
  
  func assertThatRetrieveDeliversFailureOnRetrievalError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
    expect(sut, toRetrieve: .failure(anyNSError()), file: file, line: line)
  }

  func assertThatRetrieveHasNoSideEffectsOnFailure(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
    expect(sut, toRetrieveTwice: .failure(anyNSError()), file: file, line: line)
  }
}


