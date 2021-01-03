//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Alex Tapia on 02/01/21.
//

import XCTest

class URLSessionHTTPClient {
  private let session: URLSession
  
  init(session: URLSession) {
    self.session = session
  }
  
  func get(from url: URL) {
    session.dataTask(with: url) { _, _, _ in }.resume()
  }
}

class URLSessionHTTPClientTests: XCTestCase {
  
  func test_getFromURL_resumesDataTaskWithURL() {
    let url = URL(string: "http://any-url.com")!
    let session = URLSessionSpy()
    let task = URLSessionDataTaskSpy()
    
    // NOTE: We need to tell the `session` to return our `task`
    // for a given url. So we created a Stubbing Mechanism:
    session.stub(url: url, task: task)
    
    let sut = URLSessionHTTPClient(session: session)
    
    sut.get(from: url)
    
    XCTAssertEqual(task.resumeCallCount, 1)
  }
  
  // MARK: - Helpers
  
  private class URLSessionSpy: URLSession {
    private var stubs = [URL: URLSessionDataTask]()
    
    func stub(url: URL, task: URLSessionDataTask) {
      stubs[url] = task
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
      return stubs[url] ?? FakeURLSessionDataTask()
    }
  }
  
  private class FakeURLSessionDataTask: URLSessionDataTask {
    // NOTE: We need to override `resume` method to avoid crash.
    override func resume() {}
  }
  
  private class URLSessionDataTaskSpy: URLSessionDataTask {
    var resumeCallCount = 0
    
    override func resume() {
      resumeCallCount += 1
    }
  }
}
