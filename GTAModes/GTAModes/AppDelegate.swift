//
//  AppDelegate.swift
//  GTA Modes
//
//  Created by Максим Педько on 26.07.2023.
//

import UIKit
import SwiftyDropbox

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var applicationFlowCoordinator: ApplicationFlowCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DBManager.shared.setupDropBox()
        
        applicationFlowCoordinator = ApplicationFlowCoordinator()
        
        return true
    }

}

