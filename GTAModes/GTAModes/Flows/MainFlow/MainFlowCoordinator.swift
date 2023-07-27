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
    
    init(container: Container) {
        self.container = Container(parent: container) {
            MainFlowAssembly().assemble(container: $0)
        }
        
        super.init()
    }
    
    private func createContainer() {
        container = Container()
        
        MainFlowAssembly().assemble(container: container)
    }
    
    func createFlow() -> UIViewController {
        let controller: MainViewController = container.autoresolve(
            argument: self as MainModelNavigationHandler
        )
        rootViewController = controller
        
        return controller
    }
    
}

extension MainFlowCoordinator: MainModelNavigationHandler {
    
    func mainModelDidRequestToGameSelection(_ model: MainModel) {
        print("go to game selection")
    }
    
}
