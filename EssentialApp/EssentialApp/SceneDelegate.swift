//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Alex Tapia on 24/07/22.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let _ = (scene as? UIWindowScene) else { return }
    
    let remoteURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
    
    let remoteClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    let remotefeedLoader = RemoteFeedLoader(url: remoteURL, client: remoteClient)
    let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)
    
    window?.rootViewController = FeedUIComposer.feedComposedWith(
      feedLoader: remotefeedLoader,
      imageLoader: remoteImageLoader)
  }

}

