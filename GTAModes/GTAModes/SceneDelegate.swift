
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        
        if GTA_NetworkStatusMonitor.shared.isNetworkAvailable {
            GTA_IAPManager.shared.gta_validateSubscriptions(
                productIdentifiers: [
                    GTA_Configurations.mainSubscriptionID,
                    GTA_Configurations.unlockFuncSubscriptionID, GTA_Configurations.unlockContentSubscriptionID
                ], completion: { [weak self] userHaveSub in                    if userHaveSub[GTA_Configurations.mainSubscriptionID] ?? false {
                    self?.gta_showMainFlow(window)
                } else {
                    self?.gta_showSubPremiumFlow(window)

                }
                })
        } else {
            self.gta_showSubPremiumFlow(window)
        }
    }
    
    private func gta_showMainFlow(_ window: UIWindow) {
        let flowCoordinator = GTAModes_MainFlowCoordinator()
        
        let controller = flowCoordinator.gta_createFlow()
        controller.modalPresentationStyle = .fullScreen
        
        let navigation = UINavigationController(rootViewController: controller)
        navigation.setNavigationBarHidden(true, animated: false)
        window.rootViewController = navigation
        window.makeKeyAndVisible()
    }
    
    private func gta_showSubPremiumFlow(_ window: UIWindow) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let unsubscribedVC = GTA_PremiumMainController()
            unsubscribedVC.modalPresentationStyle = .fullScreen
            window.rootViewController = unsubscribedVC
            window.makeKeyAndVisible()
        })
    }
    
}
