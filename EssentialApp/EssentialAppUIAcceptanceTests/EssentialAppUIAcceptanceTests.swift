//
//  EssentialAppUIAcceptanceTests.swift
//  EssentialAppUIAcceptanceTests
//
//  Created by Alex Tapia on 04/04/23.
//

import XCTest

final class EssentialAppUIAcceptanceTests: XCTestCase {
  
  func test_onLaunch_displayRemoteFeedWhenCustomerHasConnectivity() {
    let app = XCUIApplication()
    
    app.launch()
    
    let feedCells = app.cells.matching(identifier: "feed-image-cell")
    XCTAssertEqual(feedCells.count, 22)
    
    let feedImage = app.images.matching(identifier: "feed-image-view").firstMatch
    XCTAssertTrue(feedImage.exists)
  }
}
