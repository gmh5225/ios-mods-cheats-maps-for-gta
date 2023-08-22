
import UIKit
import WebKit

protocol MapNavigationHandler: AnyObject {
    
    func mapDidRequestToBack()
    
}

class GTAModes_MapViewController: GTAModes_NiblessViewController {
    
    private let gtaModes_navigationHandler: MapNavigationHandler
    private let gtaModes_webView = WKWebView()
    private let customNavigation: GTAModes_CustomNavigationView
    
    init(navigationHandler: MapNavigationHandler) {
        self.gtaModes_navigationHandler = navigationHandler
        self.customNavigation = GTAModes_CustomNavigationView(.map)
        
        super.init()
        customNavigation.leftButtonAction = { [weak self] in
            self?.gtaModes_navigationHandler.mapDidRequestToBack()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gta_setupView()
        gta_webViewConfigure()
    }
    
    private func gta_setupView() {
        
        view.addSubview(customNavigation)
        customNavigation.gta_layout {
            $0.top.equal(to: view.safeAreaLayoutGuide.topAnchor, offsetBy: 21.0)
            $0.leading.equal(to: view.leadingAnchor, offsetBy: 20.0)
            $0.trailing.equal(to: view.trailingAnchor, offsetBy: -20.0)
            $0.height.equal(to: 36.0)
        }
        
        view.addSubview(gtaModes_webView)
        gtaModes_webView.gta_layout {
            $0.leading.equal(to: view.leadingAnchor, offsetBy: 30.0)
            $0.trailing.greaterThanOrEqual(to: view.trailingAnchor, offsetBy: -30.0)
            $0.top.equal(to: customNavigation.bottomAnchor, offsetBy: 20.0)
            $0.bottom.equal(to: self.view.safeAreaLayoutGuide.bottomAnchor, offsetBy: -20.0)
        }
        gtaModes_webView.layer.cornerRadius = 12.0
        gtaModes_webView.layer.masksToBounds = true
    }
    
    private func gta_webViewConfigure() {
        
        if let htmlPath = Bundle.main.path(forResource: "map", ofType: "html") {
            let fileURL = URL(fileURLWithPath: htmlPath)
            gtaModes_webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL.deletingLastPathComponent())
        }
        
    }
    
}
