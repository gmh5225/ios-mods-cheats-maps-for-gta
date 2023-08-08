//
//  CustomNavigationView.swift
//  GTAModes
//
//  Created by Максим Педько on 09.08.2023.
//

import Foundation
import UIKit

public enum NavType {
    
    case gameSelect, gameModes, checkList, map
    
}

public final class CustomNavigationView: NiblessView {
    
    public var leftButtonAction: (() -> Void)?
    public var rightButtonAction: (() -> Void)?
    
    private let leftButton = UIButton(type: .custom)
    private let titleLabel = UILabel()
    private let rightButton = UIButton(type: .custom)
    private let type: NavType
    private let titleString: String?
    
    public init(_ type: NavType, titleString: String? = nil) {
      self.type = type
      self.titleString = titleString
      super.init()

      initialConfiguration()
    }
    
}

extension CustomNavigationView {
    
    private func initialConfiguration() {
        backgroundColor = .clear
        addSubviews(leftButton, rightButton, titleLabel)
        switch type {
        case .gameSelect:
            addLeftButton(UIImage(named: "backToMainIcon") ?? UIImage())
            addTitle("Cheats")
            
        case .gameModes:
            addLeftButton(UIImage(named: "backIcon") ?? UIImage())
            addFilterButton()
            addTitle(titleString ?? "Cheats")
            
        case .checkList:
            addLeftButton(UIImage(named: "backToMainIcon") ?? UIImage())
            addFilterButton()
            addTitle("Checklist")
            
        case .map:
            addLeftButton(UIImage(named: "backToMainIcon") ?? UIImage())
            addTitle("Map")
        }
    }
    
    private func addFilterButton() {
        rightButton.layout {
            $0.trailing.equal(to: self.trailingAnchor)
            $0.top.equal(to: self.topAnchor)
            $0.bottom.equal(to: self.bottomAnchor)
            $0.height.equal(to: 32.0)
            $0.width.equal(to: 32.0)
        }
        
        rightButton.setImage(UIImage(named: "filterIcon"), for: .normal)
        rightButton.addTarget(self, action: #selector(filterButtonAction), for: .touchUpInside)
    }
    
    private func addLeftButton(_ image: UIImage) {
        leftButton.layout {
            $0.leading.equal(to: self.leadingAnchor)
            $0.top.equal(to: self.topAnchor)
            $0.bottom.equal(to: self.bottomAnchor)
            $0.height.equal(to: 32.0)
            $0.width.equal(to: 32.0)
        }
        leftButton.setImage(image, for: .normal)
        leftButton.addTarget(self, action: #selector(leftBarButtonTapped), for: .touchUpInside)
    }
    
    private func addTitle(_ title: String) {
        titleLabel.layout {
            $0.leading.equal(to: leftButton.trailingAnchor, offsetBy: 20.0)
            $0.centerY.equal(to: leftButton.centerYAnchor)
            $0.trailing.greaterThanOrEqual(to: rightButton.leadingAnchor, offsetBy: 20.0)
        }
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Inter-Bold", size: 30)
        titleLabel.textColor = .white
    }
    
    @objc
    private func filterButtonAction() {
        rightButtonAction?()
    }
    
    @objc
    private func leftBarButtonTapped() {
        leftButtonAction?()
    }
    
    
}
