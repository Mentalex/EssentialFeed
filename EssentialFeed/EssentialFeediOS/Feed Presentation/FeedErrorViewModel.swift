//
//  FeedErrorViewModel.swift
//  EssentialFeediOS
//
//  Created by Alex Tapia on 04/11/21.
//

struct FeedErrorViewModel {
  let message: String?
  
  static var noError: FeedErrorViewModel {
    return FeedErrorViewModel(message: nil)
  }
  
  static func error(message: String) -> FeedErrorViewModel {
    return FeedErrorViewModel(message: message)
  }
}
