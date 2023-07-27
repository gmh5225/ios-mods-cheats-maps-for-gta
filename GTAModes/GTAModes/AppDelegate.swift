//
//  AppDelegate.swift
//  GTA Modes
//
//  Created by Максим Педько on 26.07.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var applicationFlowCoordinator: ApplicationFlowCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        applicationFlowCoordinator = ApplicationFlowCoordinator()
        
        return true
    }

}

