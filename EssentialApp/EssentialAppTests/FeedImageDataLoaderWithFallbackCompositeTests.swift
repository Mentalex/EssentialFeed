//
//  FeedImageDataLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Alex Tapia on 18/10/22.
//

import XCTest
import EssentialFeed

class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {
  private let primary: FeedImageDataLoader
  
  init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {
    self.primary = primary
  }
  
  private class Task: FeedImageDataLoaderTask {
    func cancel() {
      
    }
  }
  
  func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
    _ = primary.loadImageData(from: url) { _ in }
    return Task()
  }
}

class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase {
  
  func test_init_doesNotLoadImageData() {
    let primaryLoader = LoaderSpy()
    let fallbackLoader = LoaderSpy()
    _ = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
    
    XCTAssertTrue(primaryLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the primary loader")
    XCTAssertTrue(fallbackLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
  }
  
  func test_loadImageData_loadsFromPrimaryLoaderFirst() {
    let anyURL = anyURL()
    let primaryLoader = LoaderSpy()
    let fallbackLoader = LoaderSpy()
    let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
    
    _ = sut.loadImageData(from: anyURL) { _ in }
    
    XCTAssertEqual(primaryLoader.loadedURLs, [anyURL], "Expected to load URL from primary loader")
    XCTAssertTrue(fallbackLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
  }
  
  // MARK: - Helpers
  
  private func anyURL() -> URL {
    return URL(string: "http://a-url.com")!
  }
  
  private class LoaderSpy: FeedImageDataLoader {
    private var messages = [(url: URL, completion: ((FeedImageDataLoader.Result) -> Void))]()
    
    var loadedURLs: [URL] {
      return messages.map { $0.url }
    }
    
    private struct Task: FeedImageDataLoaderTask {
      func cancel() {}
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
      messages.append((url, completion))
      return Task()
    }
  }
}
