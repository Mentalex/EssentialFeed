//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Alex Tapia on 20/12/20.
//

import Foundation

public typealias RemoteFeedLoader = RemoteLoader<[FeedImage]>

public extension RemoteFeedLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: FeedItemsMapper.map)
    }
}
