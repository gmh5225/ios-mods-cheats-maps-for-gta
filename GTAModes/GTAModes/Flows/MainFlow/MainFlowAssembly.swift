//
//  MainFlowAssembly.swift
//  GTA Modes
//
//  Created by Максим Педько on 27.07.2023.
//

import Foundation
import Swinject

final class MainFlowAssembly: Assembly {
    
    func assemble(container: Container) {
      container.register(
        MainViewController.self
      ) { (_, navigationHandler: MainModelNavigationHandler) in
        let model = MainModel(
          navigationHandler: navigationHandler
        )
        let viewModel = MainViewModel(model: model)
        
        return MainViewController(viewModel: viewModel)
      }.inObjectScope(.transient)
    }
    
}
