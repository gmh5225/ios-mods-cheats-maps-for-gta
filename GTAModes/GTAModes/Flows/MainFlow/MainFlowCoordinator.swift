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
        let controller = MainViewController(model: model)
        rootViewController = controller
        
        return controller
    }
    
}

extension MainFlowCoordinator: MainModelNavigationHandler {
    
    func mainModelDidRequestToGameSelection(_ model: MainModel) {
        let model = GSModel(navigationHandler: self as GSModelNavigationHandler)
        let controller = GSViewController(model: model)
        
        rootViewController?.navigationController?.present(controller, animated: true)
    }
    
    func mainModelDidRequestToChecklist(_ model: MainModel) {
        let model = ChecklistModel(navigationHandler: self as ChecklistModelNavigationHandler)
        let controller = ChecklistViewController(model: model)
        
        rootViewController?.navigationController?.present(controller, animated: true)
    }
    
    
    
}

extension MainFlowCoordinator: GSModelNavigationHandler {
    func gsModelDidRequestToGameSelection(_ model: MainModel) {
        print("sss")
    }
    
}

extension MainFlowCoordinator: ChecklistModelNavigationHandler {
    
    func checklistModelDidRequestToGameSelection(_ model: MainModel) {
        print("sss")
    }
    
}


