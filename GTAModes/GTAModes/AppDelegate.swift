

import UIKit
import SwiftyDropbox
import UIKit
import Pushwoosh
import Adjust
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var applicationFlowCoordinator: ApplicationFlowCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        NetworkStatusMonitor.shared.startMonitoring()
        
        ThirdPartyServicesManager.shared.initializeAdjust()
        ThirdPartyServicesManager.shared.initializePushwoosh(delegate: self)
        ThirdPartyServicesManager.shared.initializeInApps()
//        GTAModes_DBManager.shared.gta_setupDropBox()
//
//        applicationFlowCoordinator = ApplicationFlowCoordinator()
        
        return true
    }

}

