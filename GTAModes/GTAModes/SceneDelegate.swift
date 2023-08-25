
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        gta_showMainFlow(window)

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
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            GTA_ThirdPartyServicesManager.shared.gta_makeATT()
        }
    }
    
}
