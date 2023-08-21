//
//  GameModesTableViewCell.swift
//  GTAModes
//
//  Created by Максим Педько on 03.08.2023.
//

import Foundation
import UIKit

final class GTAModes_GameCheatsTableViewCell: UITableViewCell, GTAModes_Reusable {
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let favoriteImage = UIImageView()
    private let firstStackView = UIStackView()
    private let secondStackView = UIStackView()
    private let contentModeView = UIView()
    private let modeTitleLabel = UILabel()
    private let screenWidth = UIScreen.main.bounds.width
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        gta_setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        favoriteImage.image = UIImage()
        titleLabel.text = ""
        firstStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        secondStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    public func gameMode_configure_cell(_ value: CheatItem) {
        titleLabel.font = UIFont(name: "Inter-Regular", size: 20)
        titleLabel.textColor = .white
        titleLabel.text = value.name
        favoriteImage.image =  UIImage(named: value.isFavorite ? "favoriteYesIcon" : "favoriteNoIcon")
        if value.code.count > 1 {
            contentModeView.isHidden = true
            firstStackView.isHidden = false
            secondStackView.isHidden = false
            print("============= ->  " + value.platform + "  <- =============" )
            let imagesListName = gta_configureCodes(value)
            print("============= ->  " + "\(imagesListName)" + "  <- =============" )
            gta_addImages(imagesListName)
        } else {
            contentModeView.isHidden = false
            firstStackView.isHidden = true
            secondStackView.isHidden = true
            modeTitleLabel.text = value.code.first ?? ""
            modeTitleLabel.font = UIFont(name: "Inter-Regular", size: 15)
            modeTitleLabel.textColor = .white
        }
    }
    
    private func gta_setupLayout() {
        contentView.backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.layout {
            $0.top.equal(to: contentView.topAnchor, offsetBy: 6.0)
            $0.bottom.equal(to: contentView.bottomAnchor, offsetBy: -6.0)
            $0.leading.equal(to: contentView.leadingAnchor, offsetBy: 20.0)
            $0.trailing.equal(to: contentView.trailingAnchor, offsetBy: -20.0)
        }
        containerView.withCornerRadius(4.0)
        containerView.withBorder()
        containerView.backgroundColor = UIColor(named: "checkCellBlue")?.withAlphaComponent(0.1)
        
        containerView.addSubview(favoriteImage)
        favoriteImage.layout {
            $0.trailing.equal(to: containerView.trailingAnchor, offsetBy: -8.0)
            $0.top.equal(to: containerView.topAnchor, offsetBy: 8.0)
            $0.height.equal(to: 28.0)
            $0.width.equal(to: 28.0)
        }
        favoriteImage.image = UIImage(named: "favoriteNoIcon")
        
        containerView.addSubview(firstStackView)
        containerView.addSubview(secondStackView)
        containerView.addSubview(titleLabel)
        titleLabel.layout {
            $0.leading.equal(to: containerView.leadingAnchor, offsetBy: 8.0)
            $0.trailing.equal(to: favoriteImage.leadingAnchor, offsetBy: -8.0)
            $0.top.equal(to: containerView.topAnchor, offsetBy: 12.0)
            $0.bottom.equal(to: firstStackView.topAnchor, offsetBy: -8.0)
        }
        
        firstStackView.layout {
            $0.top.equal(to: titleLabel.bottomAnchor, offsetBy: 8.0)
            $0.leading.equal(to: containerView.leadingAnchor, offsetBy: 8.0)
            $0.trailing.lessThanOrEqual(to: containerView.trailingAnchor, offsetBy: -8.0)
        }
        secondStackView.layout {
            $0.top.equal(to: firstStackView.bottomAnchor, offsetBy: 8.0)
            $0.leading.equal(to: containerView.leadingAnchor, offsetBy: 8.0)
            $0.trailing.lessThanOrEqual(to: containerView.trailingAnchor, offsetBy: -8.0)
            $0.bottom.equal(to: containerView.bottomAnchor, offsetBy: -8.0)
        }
        gta_configureStackView(firstStackView)
        gta_configureStackView(secondStackView)
        
        containerView.addSubview(contentModeView)
        contentModeView.layout {
            $0.top.equal(to: titleLabel.bottomAnchor, offsetBy: 8.0)
            $0.leading.equal(to: containerView.leadingAnchor, offsetBy: 8.0)
            $0.trailing.lessThanOrEqual(to: containerView.trailingAnchor, offsetBy: -8.0)
            $0.bottom.equal(to: containerView.bottomAnchor, offsetBy: -8.0)
        }
        
        contentModeView.addSubview(modeTitleLabel)
        modeTitleLabel.layout {
            $0.top.equal(to: contentModeView.topAnchor, offsetBy: 4.0)
            $0.bottom.equal(to: contentModeView.bottomAnchor, offsetBy: -4.0)
            $0.leading.equal(to: contentModeView.leadingAnchor, offsetBy: 8.0)
            $0.trailing.equal(to: contentModeView.trailingAnchor, offsetBy: -8.0)
            $0.centerY.equal(to: contentModeView.centerYAnchor)
        }
        contentModeView.withCornerRadius(4.0)
        contentModeView.withBorder(width: 1.0, color: UIColor(named: "blueLight")!)
        contentModeView.backgroundColor = UIColor(named: "blueLight")?.withAlphaComponent(0.1)
        containerView.layoutIfNeeded()
    }
    
    private func gta_addImages(_ imagesName: [String]) {
        var imageIndex: Int = 0
        for image in imagesName {
            let imageView = UIImageView(image: UIImage(named: image))
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layout {
                $0.height.equal(to: 25.0)
                $0.width.equal(to: 25.0)
            }
            if imageIndex <= Int(screenWidth) / 41 {
                firstStackView.addArrangedSubview(imageView)
            } else {
                secondStackView.addArrangedSubview(imageView)
            }
            imageIndex += 1
            
        }
        
    }
    
    func gta_configureCodes(_ value: CheatItem) -> [String] {
        var trueCode: [String] = []
        
        if value.platform == "ps" {
            value.code.forEach { [weak self] code in
                guard let self = self else { return }
                
                let imageAssetName = self.gta_configurePSCode(code.uppercased())
                if imageAssetName == "" {
                    print(code)
                    print(value.code)
                }
                trueCode.append(imageAssetName)
            }
        }
        
        if value.platform == "xbox" {
            value.code.forEach { [weak self] code in
                guard let self = self else { return }
                
                let imageAssetName = self.gta_configureXBoxCode(code.uppercased())
                if imageAssetName == "" {
                    print(code)
                    print(value.code)
                }
                trueCode.append(imageAssetName)
            }
        }
        
        return trueCode
    }
    
    func gta_configurePSCode(_ code: String) -> String {
        if code == "TRIANGLE" {
            return "s_triangle"
        }
        if code == "SQUARE" {
            return "s_square"
        }
        if code == "CIRCLE" || code == "O" {
            return "s_circle"
        }
        if code == "X" {
            return "s_cross"
        }
        if code == "R1" {
            return "s_r1"
        }
        if code == "R2" {
            return "s_r2"
        }
        if code == "L1" {
            return "s_l1"
        }
        if code == "L2" {
            return "s_l2"
        }
        if code == "RIGHT" {
            return "s_right"
        }
        if code == "LEFT" {
            return "s_left"
        }
        if code == "DOWN" {
            return "s_down"
        }
        if code == "UP" {
            return "s_up"
        }
        return ""
    }
    
    func gta_configureXBoxCode(_ code: String) -> String {
        if code == "Y" {
            return "m_y"
        }
        if code == "B" {
            return "m_b"
        }
        if code == "A" {
            return "m_a"
        }
        if code == "X" {
            return "m_x"
        }
        if code == "RB" {
            return "m_rb"
        }
        if code == "RT" {
            return "m_rt"
        }
        if code == "LB" {
            return "m_lb"
        }
        if code == "LT" {
            return "m_lt"
        }
        if code == "RIGHT" {
            return "m_right"
        }
        if code == "LEFT" {
            return "m_left"
        }
        if code == "DOWN" || code == "Down" {
            return "m_down"
        }
        if code == "UP" {
            return "m_up"
        }
        
        if code == "R" || code == "L" || code == "BLACK" || code == "WHITE" {
            return "m_up"
        }
        return ""
    }
    
    func gta_configureStackView(_ stackView: UIStackView) {
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .center
    }
    
}
