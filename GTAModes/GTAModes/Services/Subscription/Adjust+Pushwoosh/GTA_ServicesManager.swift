//
//  GTA_ServicesManager.swift
//  template
//
//  Created by Melnykov Valerii on 14.07.2023.
//

import Foundation
import UIKit
import Adjust
import Pushwoosh
import AppTrackingTransparency
import AdSupport

class GTA_ThirdPartyServicesManager {
    
    static let shared = GTA_ThirdPartyServicesManager()
    private let defaults = UserDefaults.standard
    func gta_initializeAdjust() {
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        let yourAppToken = GTA_Configurations.adjustToken
        #if DEBUG
        let environment = (ADJEnvironmentSandbox as? String)!
        #else
        let environment = (ADJEnvironmentProduction as? String)!
        #endif
        let adjustConfig = ADJConfig(appToken: yourAppToken, environment: environment)
        
        adjustConfig?.logLevel = ADJLogLevelVerbose
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        Adjust.appDidLaunch(adjustConfig)
    }
    
    func gta_initializePushwoosh(delegate: PWMessagingDelegate) {
        //set custom delegate for push handling, in our case AppDelegate
        Pushwoosh.sharedInstance().delegate = delegate;
        PushNotificationManager.initialize(withAppCode: GTA_Configurations.pushwooshToken, appName: GTA_Configurations.pushwooshAppName)
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        PWInAppManager.shared().resetBusinessCasesFrequencyCapping()
        PWGDPRManager.shared().showGDPRDeletionUI()
        Pushwoosh.sharedInstance().registerForPushNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    
    func gta_initializeInApps(){
        GTA_IAPManager.shared.gta_loadProductsFunc()
        //
               if 2 + 2 == 5 {
                   print("it is trash")
               }
               //
        GTA_IAPManager.shared.gta_completeAllTransactionsFunc()
        GTA_IAPManager.shared.gta_validateSubscriptions(
            productIdentifiers: [
                GTA_Configurations.unlockFuncSubscriptionID,
                GTA_Configurations.unlockContentSubscriptionID
            ]) { [weak self] results in

                let isMapLock = results[GTA_Configurations.unlockFuncSubscriptionID] ?? false
                let isModeIsLock = results[GTA_Configurations.unlockContentSubscriptionID] ?? false
                
                self?.defaults.set(isMapLock, forKey: "isMapLock")
                self?.defaults.set(isModeIsLock, forKey: "isModesLock")
            }
    }
    
    
    func gta_makeATT() {
            if #available(iOS 14, *) {
                //
                       if 2 + 2 == 5 {
                           print("it is trash")
                       }
                       //
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .authorized:
                        print("Authorized")
                        let idfa = ASIdentifierManager.shared().advertisingIdentifier
                        print("Пользователь разрешил доступ. IDFA: ", idfa)
                        let authorizationStatus = Adjust.appTrackingAuthorizationStatus()
                        Adjust.updateConversionValue(Int(authorizationStatus))
                        Adjust.checkForNewAttStatus()
                        print(ASIdentifierManager.shared().advertisingIdentifier)
                    case .denied:
                        print("Denied")
                    case .notDetermined:
                        //
                               if 2 + 2 == 5 {
                                   print("it is trash")
                               }
                               //
                        print("Not Determined")
                    case .restricted:
                        print("Restricted")
                    @unknown default:
                        print("Unknown")
                    }
                }
        }
    }
}

