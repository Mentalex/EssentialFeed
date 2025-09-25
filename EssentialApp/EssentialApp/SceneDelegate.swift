//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Alex Tapia on 24/07/22.
//

import UIKit
import CoreData
import Combine
import EssentialFeed
import EssentialFeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  
  private lazy var httpClient: HTTPClient = {
    URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
  }()
  
  private lazy var store: FeedStore & FeedImageDataStore = {
    try! CoreDataFeedStore(
      storeURL: NSPersistentContainer
        .defaultDirectoryURL()
        .appendingPathComponent("feed-store.sqlite"))
  }()
  
  private lazy var localFeedLoader: LocalFeedLoader = {
    LocalFeedLoader(store: store, currentDate: Date.init)
  }()
  
  convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore) {
    self.init()
    self.httpClient = httpClient
    self.store = store
  }
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else { return }
    
    window = UIWindow(windowScene: scene)
    configureWindow()
  }
  
  func configureWindow() {
    let remoteImageLoader = RemoteFeedImageDataLoader(client: httpClient)
    let localImageDataLoader = LocalFeedImageDataLoader(store: store)
    
    window?.rootViewController = UINavigationController(
      rootViewController: FeedUIComposer.feedComposedWith(
        feedLoader: makeRemoteFeedLoaderWithLocalFallback,
        imageLoader: FeedImageDataLoaderWithFallbackComposite(
          primary: localImageDataLoader,
          fallback: FeedImageDataLoaderCacheDecorator(
            decoratee: remoteImageLoader,
            cache: localImageDataLoader))))
    
    window?.makeKeyAndVisible()
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    localFeedLoader.validateCache() { _ in }
  }
  
  private func makeRemoteFeedLoaderWithLocalFallback() -> FeedLoader.Publisher {
    let remoteURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!

    let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: httpClient)
    
    return remoteFeedLoader
      .loadPublisher()
      .caching(to: localFeedLoader)
      .fallback(to: localFeedLoader.loadPublisher)
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
