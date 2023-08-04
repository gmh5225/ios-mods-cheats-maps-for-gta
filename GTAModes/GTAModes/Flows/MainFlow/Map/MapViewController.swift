//
//  MapViewController.swift
//  GTAModes
//
//  Created by Максим Педько on 01.08.2023.
//

import UIKit
import WebKit

class MapViewController: NiblessViewController {
    
    //    private let model: MapModel
    
    private let webView = WKWebView()
    
    override init() {
        //        self.model = model
        
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        webViewConfigure()
    }
    
    private func setupView() {
        navigationItem.title = ""
        view.addSubview(webView)
        webView.layout {
            $0.leading.equal(to: view.leadingAnchor, offsetBy: 30.0)
            $0.trailing.greaterThanOrEqual(to: view.trailingAnchor, offsetBy: -30.0)
            $0.top.equal(to: view.topAnchor, offsetBy: 80.0)
            $0.bottom.equal(to: view.bottomAnchor, offsetBy: -80.0)
        }
        webView.layer.cornerRadius = 12.0
        webView.layer.masksToBounds = true
    }
    
    private func webViewConfigure() {
                if let htmlPath = Bundle.main.path(forResource: "index", ofType: "html") {
                    let url = URL(fileURLWithPath: htmlPath)
                    let request = URLRequest(url: url)
                    webView.load(request)
                }
        
//        if let url = URL(string: "https://leafletjs.com/examples/mobile/example.html") {
//            let request = URLRequest(url: url)
//            webView.load(request)
//        }
    }
    
}
