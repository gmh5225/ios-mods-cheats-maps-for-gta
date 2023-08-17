//
//  ApplicationFlowCoordinator.swift
//  GTA Modes
//
//  Created by Максим Педько on 26.07.2023.
//

import Foundation
import UIKit

final class ApplicationFlowCoordinator: NSObject {
    
    private(set) var window: UIWindow!
    
    override init() {
        super.init()
        
    }
    
    func gtaModes_start(with launchViewController: UIViewController?, on window: UIWindow) {
        self.window = window
        if let launchViewController = launchViewController {
            gtaModes_setWindowRootViewController(with: launchViewController)
        }
        
        gtaModes_presentMainFlow()
    }
    
    func gtaModes_presentMainFlow() {
        let flowCoordinator = GTAModes_MainFlowCoordinator()
        
        let controller = flowCoordinator.gta_createFlow()
        let navigation = UINavigationController(rootViewController: controller)
        navigation.setNavigationBarHidden(true, animated: false)
        gtaModes_setWindowRootViewController(with: navigation)
    }
    
    func gtaModes_setWindowRootViewController(with viewController: UIViewController) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        if window.rootViewController != nil {
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil)
        }
    }
    
}
