

import UIKit
import SwiftyDropbox

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var applicationFlowCoordinator: ApplicationFlowCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GTAModes_DBManager.shared.gta_setupDropBox()
        
        applicationFlowCoordinator = ApplicationFlowCoordinator()
        
        return true
    }

}

