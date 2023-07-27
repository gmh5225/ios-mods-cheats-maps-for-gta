//
//  NiblessViewController.swift
//  GTA Modes
//
//  Created by Максим Педько on 27.07.2023.
//

import UIKit

/// Base UIViewController for all custom controllers used in this module
open class NiblessViewController: UIViewController {
    
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required public init?(coder aDecoder: NSCoder) {
    fatalError("Init is not implemented")
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
//    navigationController?.navigationBar.applyDefaultAppearance()
    
  }

}
