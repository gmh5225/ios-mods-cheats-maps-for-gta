
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var applicationFlowCoordinator: ApplicationFlowCoordinator? {
      (UIApplication.shared.delegate as? AppDelegate)?.applicationFlowCoordinator
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let launchViewController = UIStoryboard(name: "LaunchScreen", bundle: .main).instantiateInitialViewController()
        applicationFlowCoordinator?.gtaModes_start(with: launchViewController, on: window)
        
        self.window = window
    }
    
}

