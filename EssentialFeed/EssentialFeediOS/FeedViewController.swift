//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Alex Tapia on 05/10/21.
//

import UIKit
import EssentialFeed

final public class FeedViewController: UITableViewController {
  
  private var loader: FeedLoader?
  
  public convenience init(loader: FeedLoader) {
    self.init()
    self.loader = loader
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: #selector(load) , for: .valueChanged)
    load()
  }
  
  @objc private func load() {
    refreshControl?.beginRefreshing()
    loader?.load { [weak self] _ in
      self?.refreshControl?.endRefreshing()
    }
  }
}
