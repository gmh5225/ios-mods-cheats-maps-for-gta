//
//  NiblessViewController.swift
//  GTA Modes
//
//  Created by Максим Педько on 27.07.2023.
//

import UIKit

open class NiblessViewController: UIViewController {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Init is not implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        
    }
    
    private func setupBackground() {
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: "bg")
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    


}

open class NiblessFilterViewController: UIViewController {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Init is not implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        
    }
    
    private func setupBackground() {
        view.backgroundColor = .black
    }
}
