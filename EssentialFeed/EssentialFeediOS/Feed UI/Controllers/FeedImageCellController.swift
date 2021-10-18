//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Alex Tapia on 12/10/21.
//

import UIKit

final class FeedImageCellController {
  
  private let viewModel: FeedImageViewModel<UIImage>
  
  init(viewModel: FeedImageViewModel<UIImage>) {
    self.viewModel = viewModel
  }
  
  func view() -> UITableViewCell {
    let cell = binded(FeedImageCell())
    viewModel.loadImageData()
    return cell
  }
  
  func preload() {
    viewModel.loadImageData()
  }
  
  func cancelLoad() {
    viewModel.cancellImageData()
  }
  
  private func binded(_ cell: FeedImageCell) -> FeedImageCell {
    cell.locationContainer.isHidden = !viewModel.hasLocation
    cell.locationLabel.text = viewModel.location
    cell.descriptionLabel.text = viewModel.description
    cell.onRetry = viewModel.loadImageData
    
    viewModel.onImageLoad = { [weak cell] image in
      cell?.feedImageView.image = image
    }
    
    viewModel.onImageLoadingStateChage = { [weak cell] isLoading in
      cell?.feedImageContainer.isShimmering = isLoading
    }
    
    viewModel.onShouldRetryImageLoadStateChange = { [weak cell] shouldRetry in
      cell?.feedImageRetryButton.isHidden = !shouldRetry
    }
    
    return cell
  }
}
