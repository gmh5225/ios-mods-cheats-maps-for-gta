
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    var applicationFlowCoordinator: ApplicationFlowCoordinator? {
        (UIApplication.shared.delegate as? AppDelegate)?.applicationFlowCoordinator
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
   
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        if NetworkStatusMonitor.shared.isNetworkAvailable {
            IAPManager.shared.validateSubscriptions(
                productIdentifiers: [Configurations.mainSubscriptionID, Configurations.unlockFuncSubscriptionID, Configurations.unlockContentSubscriptionID], completion: { userHaveSub in
                    userHaveSub[Configurations.mainSubscriptionID] ?? false
                    if userHaveSub[Configurations.mainSubscriptionID] ?? false {
                        
                        let flowCoordinator = GTAModes_MainFlowCoordinator()
                        
                        let controller = flowCoordinator.gta_createFlow()
                        controller.modalPresentationStyle = .fullScreen
                        window.rootViewController = controller
                        window.makeKeyAndVisible()
                        
                        
                        //        let window = UIWindow(windowScene: windowScene)
                        //        let launchViewController = UIStoryboard(name: "LaunchScreen", bundle: .main).instantiateInitialViewController()
                        //        applicationFlowCoordinator?.gtaModes_start(with: launchViewController, on: window)
                        //
                        //        self.window = window
                        
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            let unsubscribedVC = PremiumMainController()
                            unsubscribedVC.modalPresentationStyle = .fullScreen
                            window.rootViewController = unsubscribedVC
                            window.makeKeyAndVisible()
                        })
                    }
                })
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                let unsubscribedVC = PremiumMainController()
                unsubscribedVC.modalPresentationStyle = .fullScreen
                window.rootViewController = unsubscribedVC
                window.makeKeyAndVisible()
            })
        }
    }
    
}

