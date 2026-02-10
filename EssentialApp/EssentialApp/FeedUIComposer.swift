//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Alex Tapia on 13/10/21.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class FeedUIComposer {
  private init() {}
  
  public static func feedComposedWith(feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>,
                                      imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) -> FeedViewController {
    let presentationAdapter = FeedLoaderPresentationAdapter(
      feedLoader: { feedLoader().dispatchOnMainQueue() })
    
    let feedController = makeFeedViewController(
      delegate: presentationAdapter,
      title: FeedPresenter.title)
    
    presentationAdapter.presenter = FeedPresenter(
      feedView: FeedViewAdapter(
        controller: feedController,
        imageLoader: { imageLoader($0).dispatchOnMainQueue() }),
      loadingView: WeakRefVirtualProxy(feedController),
      errorView: WeakRefVirtualProxy(feedController))
    
    return feedController
  }
  
  static func makeFeedViewController(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
    let bundle = Bundle(for: FeedViewController.self)
    let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
    let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
    feedController.delegate = delegate
    feedController.title = title
    return feedController
  }
}
