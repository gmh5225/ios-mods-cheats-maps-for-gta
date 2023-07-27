//
//  MainViewController.swift
//  GTA Modes
//
//  Created by Максим Педько on 27.07.2023.
//

import UIKit

class MainViewController: NiblessViewController {
    
    private let viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
      self.viewModel = viewModel
      
      super.init()
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
    
        view.backgroundColor = .yellow
    }
    
}
