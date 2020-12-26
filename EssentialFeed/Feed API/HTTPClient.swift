//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Alex Tapia on 25/12/20.
//

import Foundation

public enum HTTPClientResult {
  case success(Data, HTTPURLResponse)
  case failure(Error)
}

public protocol HTTPClient {
  func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
