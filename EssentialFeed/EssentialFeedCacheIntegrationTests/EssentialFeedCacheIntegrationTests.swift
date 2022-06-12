//
//  EssentialFeedCacheIntegrationTests.swift
//  EssentialFeedCacheIntegrationTests
//
//  Created by Alex Tapia on 28/09/21.
//

import XCTest
import EssentialFeed

class EssentialFeedCacheIntegrationTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    
    setupEmptyStoreState()
  }
  
  override func tearDown() {
    super.tearDown()
    
    undoStoreSideEffects()
  }

  // MARK: - LocalFeedLoader Tests
  
  func test_loadFeed_deliversNoItemsOnEmptyCache() {
    let sut = makeFeedLoader()

    expect(sut, toLoad: [])
  }
  
  func test_loadFeed_deliversItemsSavedOnASeparateInstance() {
    let feedLoaderToPerformSave = makeFeedLoader()
    let feedLoaderToPerformLoad = makeFeedLoader()
    let feed = uniqueImageFeed().models

    save(feed, with: feedLoaderToPerformSave)
    
    expect(feedLoaderToPerformLoad, toLoad: feed)
  }
  
  func test_saveFeed_overridesItemsSavedOnASeparateInstance() {
    let feedLoaderToPerformFirstSave = makeFeedLoader()
    let feedLoaderToPerformLastSave = makeFeedLoader()
    let feedLoaderToPerformLoad = makeFeedLoader()
    let firstFeed = uniqueImageFeed().models
    let latestFeed = uniqueImageFeed().models

    save(firstFeed, with: feedLoaderToPerformFirstSave)
    
    save(latestFeed, with: feedLoaderToPerformLastSave)
    
    expect(feedLoaderToPerformLoad, toLoad: latestFeed)
  }
  
  // MARK: - LocalFeedImageDataLoader Tests
  
  func test_loadImageData_deliversSavedDataOnASeparateInstance() {
    let imageLoaderToPerformSave = makeImageLoader()
    let imageLoaderToPerforLoad = makeImageLoader()
    let feedLoader = makeFeedLoader()
    let image = uniqueImage()
    let dataToSave = anyData()
    
    save([image], with: feedLoader)
    save(dataToSave, for: image.url, with: imageLoaderToPerformSave)
    
    expect(imageLoaderToPerforLoad, toLoad: dataToSave, for: image.url)
  }

  // MARK: - Helpers

  private func makeFeedLoader(file: StaticString = #filePath,
                              line: UInt = #line) -> LocalFeedLoader {
    let storeURL = testSpecificStoreURL()
    let store = try! CoreDataFeedStore(storeURL: storeURL)
    let sut = LocalFeedLoader(store: store, currentDate: Date.init)
    trackForMemoryLeaks(store, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return sut
  }
  
  private func makeImageLoader(file: StaticString = #filePath,
                               line: UInt = #line) -> LocalFeedImageDataLoader {
    let storeURL = testSpecificStoreURL()
    let store = try! CoreDataFeedStore(storeURL: storeURL)
    let sut = LocalFeedImageDataLoader(store: store)
    trackForMemoryLeaks(store, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return sut
  }
  
  private func save(_ feed: [FeedImage], with sut: LocalFeedLoader, file: StaticString = #filePath, line: UInt = #line) {
    let exp = expectation(description: "Wait for save completion")
    sut.save(feed) { result in
      if case let Result.failure(error) = result {
        XCTFail("Expected to save feed successfully, got error: \(error)", file: file, line: line)
      }
      exp.fulfill()
    }
    wait(for: [exp], timeout: 1.0)
  }
  
  private func expect(_ sut: LocalFeedLoader, toLoad expectedFeed: [FeedImage], file: StaticString = #filePath, line: UInt = #line) {
    let exp = expectation(description: "Wait for load completion")
    sut.load { result in
      switch result {
      case let .success(loadedFeed):
        XCTAssertEqual(loadedFeed, expectedFeed, file: file, line: line)
        
      case let .failure(error):
        XCTFail("Expected successful feed result, got \(error) instead", file: file, line: line)
      }

      exp.fulfill()
    }

    wait(for: [exp], timeout: 1.0)
  }
  
  private func save(_ data: Data,
                    for url: URL,
                    with loader: LocalFeedImageDataLoader,
                    file: StaticString = #filePath,
                    line: UInt = #line) {
    let saveExp = expectation(description: "Wait for save completion")
    loader.save(data, for: url) { result in
      if case let Result.failure(error) = result {
        XCTFail("Expected to save image data successfully, got error: \(error)", file: file, line: line)
      }
      saveExp.fulfill()
    }
    wait(for: [saveExp], timeout: 1.0)
  }
  
  private func expect(_ sut: LocalFeedImageDataLoader,
                      toLoad expectedData: Data,
                      for url: URL,
                      file: StaticString = #filePath,
                      line: UInt = #line) {
    let loadExp = expectation(description: "Wait for load completion")
    _ = sut.loadImageData(from: url) { result in
      switch result {
      case .success(let loadedData):
        XCTAssertEqual(loadedData, expectedData, file: file, line: line)
      case .failure(let error):
        XCTFail("Expected successful image data result, got \(error) instead", file: file, line: line)
      }
      loadExp.fulfill()
    }
    wait(for: [loadExp], timeout: 1.0)
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
