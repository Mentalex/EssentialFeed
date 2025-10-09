//
//  CombineHelpers.swift
//  EssentialApp
//
//  Created by Alex Tapia on 09/10/25.
//

import Foundation
import Combine
import EssentialFeed

public extension FeedImageDataLoader {
  typealias Publisher = AnyPublisher<Data, Error>
  
  func loadImageDataPublisher(from url: URL) -> Publisher {
    var task: FeedImageDataLoaderTask?
    
    return Deferred {
      Future { completion in
        task = self.loadImageData(from: url, completion: completion)
      }
    }
    .handleEvents(receiveCancel: { task?.cancel() })
    .eraseToAnyPublisher()
  }
}

extension Publisher where Output == Data {
  func caching(to cache: FeedImageDataCache, using url: URL) -> AnyPublisher<Output, Failure> {
    handleEvents(receiveOutput: { data in
      cache.saveIgnoringResult(data, for: url)
    }).eraseToAnyPublisher()
  }
}

extension FeedImageDataCache {
    func saveIgnoringResult(_ data: Data, for url: URL) {
        save(data, for: url) { _ in }
    }
}

public extension FeedLoader {
  typealias Publisher = AnyPublisher<[FeedImage], Error>

  func loadPublisher() -> Publisher {
    Deferred {
      Future(self.load)
    }
    .eraseToAnyPublisher()
  }
}

extension Publisher {
  func fallback(to fallbackPublisher: @escaping () -> AnyPublisher<Output, Failure>) -> AnyPublisher<Output, Failure> {
    self.catch { _ in fallbackPublisher() }.eraseToAnyPublisher()
  }
}

extension Publisher where Output == [FeedImage] {
  func caching(to cache: FeedCache) -> AnyPublisher<Output, Failure> {
    handleEvents(receiveOutput: cache.saveIgnoringResult).eraseToAnyPublisher()
  }
}

private extension FeedCache {
    func saveIgnoringResult(_ feed: [FeedImage]) {
        save(feed) { _ in }
    }
}

extension Publisher {
  func dispatchOnMainQueue() -> AnyPublisher<Output, Failure> {
    receive(on: DispatchQueue.immediateWhenOnMainQueueSheduler).eraseToAnyPublisher()
  }
}

extension DispatchQueue {
  static var immediateWhenOnMainQueueSheduler: ImmediateWhenOnMainQueueScheduler {
    ImmediateWhenOnMainQueueScheduler()
  }
  
  struct ImmediateWhenOnMainQueueScheduler: Scheduler {
    typealias SchedulerTimeType = DispatchQueue.SchedulerTimeType
    typealias SchedulerOptions = DispatchQueue.SchedulerOptions
    
    var now: SchedulerTimeType {
      main.now
    }
    
    var minimumTolerance: SchedulerTimeType.Stride {
      main.minimumTolerance
    }
    
    func schedule(options: SchedulerOptions?, _ action: @escaping () -> Void) {
      guard Thread.isMainThread else {
       return main.schedule(options: options, action)
      }
      
      action()
    }
    
    func schedule(after date: SchedulerTimeType, interval: SchedulerTimeType.Stride, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> any Cancellable {
      main.schedule(after: date, interval: interval, tolerance: tolerance, options: options, action)
    }
    
    func schedule(after date: SchedulerTimeType, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) {
      main.schedule(after: date, tolerance: tolerance, options: options, action)
    }
  }
}
