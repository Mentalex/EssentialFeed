//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Alex Tapia on 24/07/22.
//

import UIKit
import CoreData
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
    let remoteURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
    
    let remotefeedLoader = RemoteFeedLoader(url: remoteURL, client: httpClient)
    let remoteImageLoader = RemoteFeedImageDataLoader(client: httpClient)
    let localImageDataLoader = LocalFeedImageDataLoader(store: store)
    
    window?.rootViewController = UINavigationController(
      rootViewController: FeedUIComposer.feedComposedWith(
        feedLoader: FeedLoaderWithFallbackComposite(
          primary: FeedLoaderCacheDecorator(
            decoratee: remotefeedLoader,
            cache: localFeedLoader),
          fallback: localFeedLoader),
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
}
