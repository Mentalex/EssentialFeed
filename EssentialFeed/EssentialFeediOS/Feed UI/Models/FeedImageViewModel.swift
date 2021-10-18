//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Alex Tapia on 17/10/21.
//

import Foundation
import EssentialFeed

final class FeedImageViewModel<Image> {
  
  typealias Observer<T> = (T) -> Void
  
  private var task: FeedImageDataLoaderTask?
  private var model: FeedImage
  private let imageLoader: FeedImageDataLoader
  private let imageTransformer: (Data) -> Image?
  
  init(model: FeedImage, imageLoader: FeedImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
    self.model = model
    self.imageLoader = imageLoader
    self.imageTransformer = imageTransformer
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
  
  var onImageLoad: Observer<Image>?
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
    if let image = (try? result.get()).flatMap(imageTransformer) {
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
