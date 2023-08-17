//
//  MapViewController.swift
//  GTAModes
//
//  Created by Максим Педько on 01.08.2023.
//

import UIKit
import WebKit

protocol MapNavigationHandler: AnyObject {
    
    func mapDidRequestToBack()
    
}

class MapViewController: NiblessViewController {
    
    private let navigationHandler: MapNavigationHandler
    private let webView = WKWebView()
    private let customNavigation: CustomNavigationView
    
    init(navigationHandler: MapNavigationHandler) {
        self.navigationHandler = navigationHandler
        self.customNavigation = CustomNavigationView(.map)
        
        super.init()
        customNavigation.leftButtonAction = { [weak self] in
            self?.navigationHandler.mapDidRequestToBack()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        webViewConfigure()
    }
    
    private func setupView() {
        
        view.addSubview(customNavigation)
        customNavigation.layout {
            $0.top.equal(to: view.safeAreaLayoutGuide.topAnchor)
            $0.leading.equal(to: view.leadingAnchor, offsetBy: 20.0)
            $0.trailing.equal(to: view.trailingAnchor, offsetBy: -20.0)
            $0.height.equal(to: 36.0)
        }
        
        view.addSubview(webView)
        webView.layout {
            $0.leading.equal(to: view.leadingAnchor, offsetBy: 30.0)
            $0.trailing.greaterThanOrEqual(to: view.trailingAnchor, offsetBy: -30.0)
            $0.top.equal(to: customNavigation.bottomAnchor, offsetBy: 20.0)
            $0.bottom.equal(to: self.view.safeAreaLayoutGuide.bottomAnchor, offsetBy: -20.0)
        }
        webView.layer.cornerRadius = 12.0
        webView.layer.masksToBounds = true
    }
    
    private func webViewConfigure() {
        
        if let htmlPath = Bundle.main.path(forResource: "map", ofType: "html") {
                    let fileURL = URL(fileURLWithPath: htmlPath)
            webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL.deletingLastPathComponent())
                }
        
//        if let url = URL(string: "https://pedkomaksim.github.io/gtavmaponline.github.io/map/map.html") {
//            let request = URLRequest(url: url)
//            webView.load(request)
//        }
    }
    
}
