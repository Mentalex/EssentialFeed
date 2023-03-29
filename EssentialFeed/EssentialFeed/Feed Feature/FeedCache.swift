//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Alex Tapia on 20/03/23.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
