//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Alex Tapia on 13/10/21.
//

import EssentialFeed
import UIKit

public final class FeedUIComposer {
  private init() {}
  
  public static func feedComposedWith(feedLoader: FeedLoader,
                                      imageLoader: FeedImageDataLoader) -> FeedViewController {
    let presenter = FeedPresenter(feedLoader: feedLoader)
    let refreshController = FeedRefreshViewController(presenter: presenter)
    let feedController = FeedViewController(refreshController: refreshController)
    presenter.loadingView = WeakRefVirtualProxy(refreshController)
    presenter.feedView = FeedViewAdapter(controller: feedController, imageLoader: imageLoader)
    return feedController
  }
}

private final class WeakRefVirtualProxy<T: AnyObject> {
  private weak var object: T?
  
  init(_ object: T?) {
    self.object = object
  }
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
  func display(_ viewModel: FeedLoadingViewModel) {
    object?.display(viewModel)
  }
}

private final class FeedViewAdapter: FeedView {
  
  private weak var controller: FeedViewController?
  private let imageLoader: FeedImageDataLoader
  
  init(controller: FeedViewController, imageLoader: FeedImageDataLoader) {
    self.controller = controller
    self.imageLoader = imageLoader
  }
  
  func display(_ viewModel: FeedViewModel) {
    controller?.tableModel = viewModel.feed.map { model in
      FeedImageCellController(
        viewModel: FeedImageViewModel(model: model, imageLoader: imageLoader, imageTransformer: UIImage.init)
      )
    }
  }
}
