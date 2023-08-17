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

public final class GTAModes_CustomNavigationView: GTAModes_NiblessView {
    
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

      gta_initialConfiguration()
    }
    
}

extension GTAModes_CustomNavigationView {
    
    private func gta_initialConfiguration() {
        backgroundColor = .clear
        addSubviews(leftButton, rightButton, titleLabel)
        switch type {
        case .gameSelect:
            gta_addLeftButton(UIImage(named: "backToMainIcon") ?? UIImage())
            gta_addTitle("Cheats")
            
        case .gameModes:
            gta_addLeftButton(UIImage(named: "backIcon") ?? UIImage())
            gta_addFilterButton()
            gta_addTitle(titleString ?? "Cheats")
            
        case .checkList:
            gta_addLeftButton(UIImage(named: "backToMainIcon") ?? UIImage())
            gta_addFilterButton()
            gta_addTitle("Checklist")
            
        case .map:
            gta_addLeftButton(UIImage(named: "backToMainIcon") ?? UIImage())
            gta_addTitle("Map")
        }
    }
    
    private func gta_addFilterButton() {
        rightButton.layout {
            $0.trailing.equal(to: self.trailingAnchor)
            $0.top.equal(to: self.topAnchor)
            $0.bottom.equal(to: self.bottomAnchor)
            $0.height.equal(to: 32.0)
            $0.width.equal(to: 32.0)
        }
        
        rightButton.setImage(UIImage(named: "filterIcon"), for: .normal)
        rightButton.addTarget(self, action: #selector(gta_filterButtonAction), for: .touchUpInside)
    }
    
    private func gta_addLeftButton(_ image: UIImage) {
        leftButton.layout {
            $0.leading.equal(to: self.leadingAnchor)
            $0.top.equal(to: self.topAnchor)
            $0.bottom.equal(to: self.bottomAnchor)
            $0.height.equal(to: 32.0)
            $0.width.equal(to: 32.0)
        }
        leftButton.setImage(image, for: .normal)
        leftButton.addTarget(self, action: #selector(gta_leftBarButtonTapped), for: .touchUpInside)
    }
    
    private func gta_addTitle(_ title: String) {
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
    private func gta_filterButtonAction() {
        rightButtonAction?()
    }
    
    @objc
    private func gta_leftBarButtonTapped() {
        leftButtonAction?()
    }
    
    
}
