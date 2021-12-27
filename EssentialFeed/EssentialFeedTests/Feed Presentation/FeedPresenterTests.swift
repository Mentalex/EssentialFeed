//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Alex Tapia on 27/12/21.
//

import XCTest

final class FeedPresenter {
  init(view: Any) {
    
  }
}

class FeedPresenterTests: XCTestCase {
 
  func test_init_doesNotSendMessagesToView() {
    let view = ViewSpy()
    
    _ = FeedPresenter(view: view)
    
    XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
  }
  
  // MARK: - Helpers
  private class ViewSpy {
    let messages = [Any]()
  }
}
