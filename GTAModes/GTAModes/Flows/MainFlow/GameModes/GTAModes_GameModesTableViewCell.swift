//
//  GTAModes_GameModesTableViewCell.swift
//  GTAModes
//
//  Created by Максим Педько on 21.08.2023.
//

import Foundation
import UIKit
import Kingfisher

final class GTAModes_GameModesTableViewCell: UITableViewCell, GTAModes_Reusable {
    
    public var shareAction: (() -> Void)?
    public var downloadAction: (() -> Void)?
    
    private var kingfisherManager: KingfisherManager
    
    weak var tableView: UITableView?
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let typeImage = UIImageView()
    private let modeImage = UIImageView()
    private let descriprionLabel = UILabel()
    private let shareButtonView = UIView()
    private var isExpanded: Bool = true {
        didSet {
          if isExpanded {
            NSLayoutConstraint.activate(collapsedConstraints)
            NSLayoutConstraint.deactivate(expandedConstraints)
          } else {
            NSLayoutConstraint.deactivate(collapsedConstraints)
            NSLayoutConstraint.activate(expandedConstraints)
          }
            descriprionLabel.isHidden = isExpanded
            stackView.isHidden = isExpanded
          contentView.layoutIfNeeded()
            containerView.layoutIfNeeded()
        }
      }
    
    private var collapsedConstraints: [NSLayoutConstraint] = []
    private var expandedConstraints: [NSLayoutConstraint] = []
    
    private let downloadButtonView = UIView()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public var dynamicExpandedHeight: CGFloat = 0.0
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.kingfisherManager = KingfisherManager.shared
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        gta_setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        descriprionLabel.text = ""
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        modeImage.image = UIImage()
    }
    
    public func gameMode_configure_cell(_ value: ModItem) {
        titleLabel.font = UIFont(name: "Inter-Regular", size: 20)
        titleLabel.textColor = .white
        titleLabel.text = value.title
        modeImage.kf.setImage(with: URL(string: value.imagePath))
        
        descriprionLabel.font = UIFont(name: "Inter-Regular", size: 20)
        descriprionLabel.textColor = .white
        descriprionLabel.text = value.description
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
        
        containerView.addSubviews(typeImage)
        typeImage.layout {
            $0.trailing.equal(to: containerView.trailingAnchor, offsetBy: -8.0)
            $0.top.equal(to: containerView.topAnchor, offsetBy: 8.0)
            $0.height.equal(to: 25.0)
            $0.width.equal(to: 25.0)
        }
        typeImage.image = UIImage(named: "longCellIcon")
        containerView.addSubview(titleLabel)
        titleLabel.layout {
            $0.leading.equal(to: containerView.leadingAnchor, offsetBy: 8.0)
            $0.trailing.equal(to: typeImage.leadingAnchor, offsetBy: -4.0)
            $0.top.equal(to: containerView.topAnchor, offsetBy: 12.0)
        }
        
        containerView.addSubview(modeImage)
        modeImage.layout {
            $0.leading.equal(to: containerView.leadingAnchor, offsetBy: 8.0)
            $0.trailing.equal(to: containerView.trailingAnchor, offsetBy: -8.0)
            $0.top.equal(to: titleLabel.bottomAnchor, offsetBy: 8.0)
            $0.height.equal(to: 218.0)
            
            collapsedConstraints.append(
              $0.bottom.equal(to: containerView.bottomAnchor, offsetBy: -8.0)
            )
        }
        
        containerView.addSubview(descriprionLabel)
        descriprionLabel.layout {
            $0.leading.equal(to: containerView.leadingAnchor, offsetBy: 8.0)
            $0.trailing.equal(to: containerView.trailingAnchor, offsetBy: -8.0)
            
            expandedConstraints.append(
                $0.top.equal(to: modeImage.bottomAnchor, offsetBy: 8.0, isActive: true)
            )
            expandedConstraints.forEach { $0.isActive = false }
            
        }
        descriprionLabel.numberOfLines = 0
        
        containerView.addSubview(stackView)
        stackView.layout {
            $0.leading.equal(to: containerView.leadingAnchor, offsetBy: 8.0)
            $0.trailing.equal(to: containerView.trailingAnchor, offsetBy: -8.0)
            $0.top.equal(to: descriprionLabel.bottomAnchor, offsetBy: 12.0)
            $0.height.equal(to: 42.0)
            
            expandedConstraints.append(
                $0.bottom.equal(to: containerView.bottomAnchor, offsetBy:  -12.0, isActive: true)
            )
            expandedConstraints.forEach { $0.isActive = false }
        }
        
        stackView.addArrangedSubview(shareButtonView)
        stackView.addArrangedSubview(downloadButtonView)
        shareButtonView.backgroundColor = UIColor(named: "blueColor")?.withAlphaComponent(0.4)
        downloadButtonView.backgroundColor = UIColor(named: "blueColor")?.withAlphaComponent(0.4)
        shareButtonView.withCornerRadius(4.0)
        shareButtonView.withBorder()
        downloadButtonView.withCornerRadius(4.0)
        downloadButtonView.withBorder()
        
        let shareView = configureButtonView(title: "Share", imageName: "shareIcon")
        shareButtonView.addSubview(shareView)
        shareView.layout {
            $0.centerX.equal(to: shareButtonView.centerXAnchor)
            $0.centerY.equal(to: shareButtonView.centerYAnchor)
        }
        
        let downloadView = configureButtonView(title: "Download", imageName: "downloadIcon")
        downloadButtonView.addSubview(downloadView)
        downloadView.layout {
            $0.centerX.equal(to: downloadButtonView.centerXAnchor)
            $0.centerY.equal(to: downloadButtonView.centerYAnchor)
        }
        
        shareButtonView.layout {
            $0.height.equal(to: 42.0)
        }
        downloadButtonView.layout {
            $0.height.equal(to: 42.0)
        }
        let shareGestrure = UITapGestureRecognizer(target: self, action: #selector(shareActionProceed))
        shareButtonView.addGestureRecognizer(shareGestrure)
        
        
        let downloadGestrure = UITapGestureRecognizer(target: self, action: #selector(downloadActionProceed))
        downloadButtonView.addGestureRecognizer(downloadGestrure)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        containerView.addGestureRecognizer(tapGesture)
        descriprionLabel.isHidden = true
        stackView.isHidden = true
    }
    
    func configureButtonView(title: String, imageName: String) -> UIView {
        let buttonView = UIView()
        let titleLabel = UILabel()
        let imageView = UIImageView()
        buttonView.addSubview(titleLabel)
        buttonView.addSubview(imageView)
        titleLabel.layout {
            $0.top.equal(to: buttonView.topAnchor)
            $0.leading.equal(to: buttonView.leadingAnchor)
            $0.trailing.equal(to: imageView.leadingAnchor, offsetBy: -10.0)
            $0.bottom.equal(to: buttonView.bottomAnchor)
        }
        imageView.layout {
            $0.height.equal(to: 26.0)
            $0.width.equal(to: 26.0)
            
            $0.trailing.equal(to: buttonView.trailingAnchor)
            $0.centerY.equal(to: buttonView.centerYAnchor)
        }
        
        titleLabel.font = UIFont(name: "Inter-Regular", size: 16)
        titleLabel.textColor = .white
        titleLabel.text = title
        
        imageView.image = UIImage(named: imageName)
        
        return buttonView
    }
    
    @objc func shareActionProceed() {
        shareAction?()
    }
    
    @objc func downloadActionProceed() {
        downloadAction?()
    }
    
    @objc private func cellTapped() {
        isExpanded.toggle()
        tableView?.beginUpdates()
        tableView?.endUpdates()
    }
    
}
