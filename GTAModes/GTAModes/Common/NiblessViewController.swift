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
    
    open func setupBackButton() {
        let image = UIImage(named: "backIcon")
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(leftBarButtonTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    open func setupBackToMenuButton() {
        let image = UIImage(named: "backToMainIcon")
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(leftBarButtonTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButtonItem
    }
    
    open func customizeNavigationBar(_ title: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Inter-Bold", size: 30)
        titleLabel.textColor = .white
        let titleView = UIView()
        titleView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.layout {
            $0.trailing.equal(to: titleView.trailingAnchor)
            $0.centerY.equal(to: titleView.centerYAnchor)
        }
        navigationItem.titleView = titleView
    }
    
    @objc
    open func leftBarButtonTapped() {
    }
    
    open func setupFilterButton() {
        let filterButton = UIButton()
        filterButton.setImage(UIImage(named: "filterIcon"), for: .normal)
        filterButton.addTarget(self, action: #selector(filterButtonAction), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: filterButton)
    }
    
    @objc
    open func filterButtonAction() {
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
