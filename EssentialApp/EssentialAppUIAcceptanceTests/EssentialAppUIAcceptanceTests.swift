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
    
    XCTAssertEqual(app.cells.count, 22)
    XCTAssertEqual(app.cells.firstMatch.images.count, 1)
  }
}
