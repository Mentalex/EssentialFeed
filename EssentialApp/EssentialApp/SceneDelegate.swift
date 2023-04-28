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
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let _ = (scene as? UIWindowScene) else { return }
    
    let remoteURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
    
    let remoteClient = makeRemoteClient()
    let remotefeedLoader = RemoteFeedLoader(url: remoteURL, client: remoteClient)
    let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)
    
    let localStoreURL = NSPersistentContainer
      .defaultDirectoryURL()
      .appendingPathComponent("feed-store.sqlite")
    
    let localStore = try! CoreDataFeedStore(storeURL: localStoreURL)
    let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
    let localImageDataLoader = LocalFeedImageDataLoader(store: localStore)
    
    window?.rootViewController = FeedUIComposer.feedComposedWith(
      feedLoader: FeedLoaderWithFallbackComposite(
        primary: FeedLoaderCacheDecorator(
          decoratee: remotefeedLoader,
          cache: localFeedLoader),
        fallback: localFeedLoader),
      imageLoader: FeedImageDataLoaderWithFallbackComposite(
        primary: localImageDataLoader,
        fallback: FeedImageDataLoaderCacheDecorator(
          decoratee: remoteImageLoader,
          cache: localImageDataLoader)))
  }
  
  private func makeRemoteClient() -> HTTPClient {
    switch UserDefaults.standard.string(forKey: "connectivity") {
    case "offline":
      return AlwaysFalingHTTPClient()
      
    default:
      return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }
  }
}

private class AlwaysFalingHTTPClient: HTTPClient {
  private class Task: HTTPClientTask {
    func cancel() {}
  }
  
  func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
    completion(.failure(NSError(domain: "offline", code: 0)))
    return Task()
  }
}
