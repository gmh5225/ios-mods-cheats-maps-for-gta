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
    
    init(navigationHandler: MapNavigationHandler) {
                self.navigationHandler = navigationHandler
        
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupBackToMenuButton()
        customizeNavigationBar("Map")
        webViewConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc
    override func leftBarButtonTapped() {
        navigationHandler.mapDidRequestToBack()
    }
    
    private func setupView() {
        navigationItem.title = ""
        view.addSubview(webView)
        webView.layout {
            $0.leading.equal(to: view.leadingAnchor, offsetBy: 30.0)
            $0.trailing.greaterThanOrEqual(to: view.trailingAnchor, offsetBy: -30.0)
            $0.top.equal(to: self.view.safeAreaLayoutGuide.topAnchor, offsetBy: 20.0)
            $0.bottom.equal(to: self.view.safeAreaLayoutGuide.bottomAnchor, offsetBy: -20.0)
        }
        webView.layer.cornerRadius = 12.0
        webView.layer.masksToBounds = true
    }
    
    private func webViewConfigure() {
        if let url = URL(string: "https://pedkomaksim.github.io/gtavmaponline.github.io/map/map.html") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
}
