//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Alex Tapia on 11/10/21.
//

import UIKit
import EssentialFeed

final class FeedRefreshViewController: NSObject {
  
  private(set) lazy var view = binded(UIRefreshControl())
  
  private let viewModel: FeedViewModel
  
  init(viewModel: FeedViewModel) {
    self.viewModel = viewModel
  }
  
  var onRefresh: (([FeedImage]) -> Void)?
  
  @objc func refresh() {
    viewModel.loadFeed()
  }
  
  private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
    viewModel.onLoadingStateChange = { [weak view] isLoading in
      if isLoading {
        view?.beginRefreshing()
      } else {
        view?.endRefreshing()
      }
    }
    view.addTarget(self, action: #selector(refresh) , for: .valueChanged)
    return view
  }
}
