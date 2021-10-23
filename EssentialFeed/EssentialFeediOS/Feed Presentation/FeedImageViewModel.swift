//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Alex Tapia on 17/10/21.
//

struct FeedImageViewModel<Image> {
  let description: String?
  let location: String?
  let image: Image?
  let isLoading: Bool
  let shouldRetry: Bool
  
  var hasLocation: Bool {
    return location != nil
  }
}
