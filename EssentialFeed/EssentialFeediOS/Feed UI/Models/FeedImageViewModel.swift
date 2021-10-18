//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Alex Tapia on 17/10/21.
//

import UIKit
import EssentialFeed

final class FeedImageViewModel {
  
  typealias Observer<T> = (T) -> Void
  
  private var task: FeedImageDataLoaderTask?
  private var model: FeedImage
  private let imageLoader: FeedImageDataLoader
  
  init(model: FeedImage, imageLoader: FeedImageDataLoader) {
    self.model = model
    self.imageLoader = imageLoader
  }
  
  var description: String? {
    return model.description
  }
  
  var location: String? {
    return model.location
  }
  
  var hasLocation: Bool {
    return location != nil
  }
  
  var onImageLoad: Observer<UIImage?>?
  var onImageLoadingStateChage: Observer<Bool>?
  var onShouldRetryImageLoadStateChange: Observer<Bool>?
  
  func loadImageData() {
    onImageLoadingStateChage?(true)
    onShouldRetryImageLoadStateChange?(false)
    task = imageLoader.loadImageData(from: model.url) { [weak self] result in
      self?.hadle(result)
    }
  }
  
  private func hadle(_ result: FeedImageDataLoader.Result) {
    if let image = (try? result.get()).flatMap(UIImage.init) {
      onImageLoad?(image)
    } else {
      onShouldRetryImageLoadStateChange?(true)
    }
    onImageLoadingStateChage?(false)
  }
  
  func cancellImageData() {
    task?.cancel()
    task = nil
  }
}
