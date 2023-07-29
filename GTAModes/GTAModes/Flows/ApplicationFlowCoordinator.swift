//
//  ApplicationFlowCoordinator.swift
//  GTA Modes
//
//  Created by Максим Педько on 26.07.2023.
//

import Foundation
import Swinject
import UIKit

final class ApplicationFlowCoordinator: NSObject {
    
    private(set) var window: UIWindow!
    private(set) var container: Container!
    
    override init() {
        super.init()
        
//        initializeDependencies()
    }
    
    func start(with launchViewController: UIViewController?, on window: UIWindow) {
        self.window = window
        if let launchViewController = launchViewController {
            setWindowRootViewController(with: launchViewController)
        }
        
        presentMainFlow()
    }
    
    func setWindowRootViewController(with viewController: UIViewController) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        if window.rootViewController != nil {
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil)
        }
    }
    
    func presentMainFlow() {
        let flowCoordinator = MainFlowCoordinator()
        
        let controller = flowCoordinator.createFlow()
        let navigation = UINavigationController(rootViewController: controller)
        
        setWindowRootViewController(with: navigation)
    }
    
}

extension ApplicationFlowCoordinator: MainModelNavigationHandler {
    
    func mainModelDidRequestToGameSelection(_ model: MainModel) {
        print("fff")
    }
    
    
}
