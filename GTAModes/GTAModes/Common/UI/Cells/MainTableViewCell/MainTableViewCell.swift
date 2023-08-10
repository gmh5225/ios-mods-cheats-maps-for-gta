//
//  MainTableViewCell.swift
//  GTAModes
//
//  Created by Максим Педько on 29.07.2023.
//
public struct MainCellData {
    
    let title: String
    let imageUrl: String
    
}

import Foundation
import UIKit
import Kingfisher

final class MainTableViewCell: UITableViewCell, Reusable {
    
    private var kingfisherManager: KingfisherManager
    
    private let containerView = UIView()
    private let backgroundImageView = UIImageView()
    private let titleLabel = UILabel()
    private let bottomBlackView = UIView()
    private let rightImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.kingfisherManager = KingfisherManager.shared
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(_ value: MainItem, fontSize: CGFloat) {
        titleLabel.text = value.title.uppercased()
        backgroundImageView.contentMode = .scaleAspectFill
        titleLabel.font = UIFont(name: "Inter-Bold", size: fontSize)
        titleLabel.textColor = .white
        backgroundImageView.kf.setImage(with: URL(string: value.imagePath)) 
    }
    
    private func setupLayout() {
        contentView.backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.layout {
            $0.top.equal(to: contentView.topAnchor, offsetBy: 6.0)
            $0.bottom.equal(to: contentView.bottomAnchor, offsetBy: -6.0)
            $0.leading.equal(to: contentView.leadingAnchor, offsetBy: 20.0)
            $0.trailing.equal(to: contentView.trailingAnchor, offsetBy: -20.0)
        }
        containerView.withCornerRadius()
        containerView.backgroundColor = .clear
        
        containerView.addSubview(backgroundImageView)
        backgroundImageView.layout {
            $0.top.equal(to: containerView.topAnchor)
            $0.bottom.equal(to: containerView.bottomAnchor)
            $0.leading.equal(to: containerView.leadingAnchor)
            $0.trailing.equal(to: containerView.trailingAnchor)
        }
        
        backgroundImageView.addSubview(bottomBlackView)
        bottomBlackView.layout {
            $0.bottom.equal(to: backgroundImageView.bottomAnchor)
            $0.leading.equal(to: backgroundImageView.leadingAnchor)
            $0.trailing.equal(to: backgroundImageView.trailingAnchor)
            $0.height.equal(to: 60.0)
        }
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.5
        blurEffectView.frame = bottomBlackView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bottomBlackView.addSubview(blurEffectView)
        
        bottomBlackView.backgroundColor = UIColor(named: "mainBlackColor")?.withAlphaComponent(0.5)
        
        bottomBlackView.addSubview(titleLabel)
        titleLabel.layout {
            $0.bottom.equal(to: bottomBlackView.bottomAnchor, offsetBy: -12.0)
            $0.leading.equal(to: bottomBlackView.leadingAnchor, offsetBy: 18.0)
            $0.top.equal(to: bottomBlackView.topAnchor, offsetBy: 12.0)
        }
        
        bottomBlackView.addSubview(rightImageView)
        rightImageView.layout {
            $0.bottom.equal(to: bottomBlackView.bottomAnchor, offsetBy: -12.0)
            $0.trailing.equal(to: bottomBlackView.trailingAnchor, offsetBy: -18.0)
            $0.top.equal(to: bottomBlackView.topAnchor, offsetBy: 12.0)
            $0.height.equal(to: 30.0)
            $0.width.equal(to: 30.0)
        }
        rightImageView.image = UIImage(named: "rightIcon")
        containerView.bringSubviewToFront(bottomBlackView)
    }
    
}
