//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by Alex Tapia on 04/11/21.
//

import UIKit

public final class ErrorView: UIView {
  
  @IBOutlet private var label: UILabel!
  
  public var message: String? {
    get { return label.text }
    set { label.text = newValue }
  }
  
  public override func awakeFromNib() {
    super.awakeFromNib()
    
    label.text = nil
  }
}
