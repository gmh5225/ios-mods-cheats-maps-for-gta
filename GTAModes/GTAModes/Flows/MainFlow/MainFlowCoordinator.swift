//
//  MainFlowCoordinator.swift
//  GTA Modes
//
//  Created by Максим Педько on 27.07.2023.
//

import Foundation
import UIKit
import Swinject

final class MainFlowCoordinator: NSObject, FlowCoordinator {

    private weak var presentedViewController: UIViewController?
    private weak var rootViewController: UIViewController?
    private weak var parentViewController: UIViewController?
    
    private var container: Container!
    
    override init() {
        super.init()
    }

    func createFlow() -> UIViewController {
        let model = MainModel(navigationHandler: self as MainModelNavigationHandler)
        let viewModel = MainViewModel(model: model)
        let controller = MainViewController(viewModel: viewModel)
        rootViewController = controller
        
        return controller
    }
    
}

extension MainFlowCoordinator: MainModelNavigationHandler {
    
    func mainModelDidRequestToGameSelection(_ model: MainModel) {
        print("go to game selection")
    }
    
}
