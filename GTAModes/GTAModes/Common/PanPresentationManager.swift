
import UIKit

final class PanPresentationManager: NSObject, UIViewControllerTransitioningDelegate {
  
  func presentationController(
    forPresented presented: UIViewController,
    presenting: UIViewController?,
    source: UIViewController
  ) -> UIPresentationController? {
    let presentationController = PanPresentationController(presented: presented, presenting: presenting)
    
    return presentationController
  }
  
}

public extension UIViewController {
  
  private static var presentationManagerKey: UInt8 = 0
  
  private var gta_presentationManager: UIViewControllerTransitioningDelegate? {
    if let manager = objc_getAssociatedObject(self, &UIViewController.presentationManagerKey)
        as? PanPresentationManager {
      return manager
    }
    
    let newManager = PanPresentationManager()
    objc_setAssociatedObject(
      self,
      &UIViewController.presentationManagerKey,
      newManager,
      .OBJC_ASSOCIATION_RETAIN
    )
    return newManager
  }
  
  func gta_presentPan(_ controller: UIViewController) {
    controller.modalPresentationStyle = .custom
    controller.transitioningDelegate = gta_presentationManager
    
    present(controller, animated: false, completion: nil)
  }
  
}
