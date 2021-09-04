//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Alex Tapia on 03/09/21.
//

import Foundation

internal struct FeedCachePolicy {
  private init() {}
  
  private static let calendar = Calendar(identifier: .gregorian)
  
  private static var maxCacheAgeInDays: Int {
    return 7
  }
  
  internal static func validate(_ timestamp: Date, against date: Date) -> Bool {
    guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
      return false
    }
    return date < maxCacheAge
  }
}
