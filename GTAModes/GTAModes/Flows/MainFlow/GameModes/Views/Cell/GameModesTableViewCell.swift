//
//  GameModesTableViewCell.swift
//  GTAModes
//
//  Created by Максим Педько on 03.08.2023.
//

import Foundation
import UIKit

public struct GameModesData {
    
    let title: String
    let imageNames: [String]
    let isFavorite: Bool
    
}

final class GameModesTableViewCell: UITableViewCell, Reusable {
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let favoriteImage = UIImageView()
    private let stackView = UIStackView()
    private let contentView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(_ value: GameModesData) {
        titleLabel.font = UIFont(name: "Inter-Regular", size: 20)
        titleLabel.textColor = .white
        titleLabel.text = value.title
        favoriteImage.image = UIImage()
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
        containerView.withCornerRadius(4.0)
        containerView.withBorder()
        containerView.backgroundColor = UIColor(named: "checkCellBlue")?.withAlphaComponent(0.1)
        
        containerView.addSubview(favoriteImage)
        favoriteImage.layout {
            $0.trailing.equal(to: containerView.trailingAnchor, offsetBy: -4.0)
            $0.top.equal(to: containerView.topAnchor, offsetBy: 12.0)
            $0.height.equal(to: 36.0)
            $0.width.equal(to: 36.0)
        }
        favoriteImage.image = UIImage(named: "favoriteIcon")
        
        containerView.addSubview(titleLabel)
        titleLabel.layout {
            $0.leading.equal(to: containerView.leadingAnchor, offsetBy: 4.0)
            $0.trailing.greaterThanOrEqual(to: swicher.leadingAnchor, offsetBy: -4.0)
            $0.top.equal(to: containerView.topAnchor, offsetBy: 12.0)
        }
        
    }
    
    private func addImages(_ images: [UIImage()]) {
        stackView.axis = .horizontal
        stackView.spacing = 8 // Adjust the spacing between images as needed
        stackView.distribution = .fillEqually // Adjust distribution mode as needed
        stackView.alignment = .center
        
        for image in images {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
            
            stackView.addArrangedSubview(imageView)
        }
        
        // Add the stack view to the main view
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
