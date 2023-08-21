//
//  FilterTableViewCell.swift
//  GTAModes
//
//  Created by Максим Педько on 31.07.2023.
//

import Foundation
import UIKit

final class GTAModes_FilterTableViewCell: UITableViewCell, GTAModes_Reusable {
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let checkImage = UIImageView()
    private let borderLineView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        gta_setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func gta_configure_cell(_ value: FilterData) {
        titleLabel.font = UIFont(name: "Inter-Regular", size: 20)
        titleLabel.textColor = .white
        titleLabel.text = value.title
        checkImage.isHidden = !value.isCheck
    }
    
    private func gta_setupLayout() {
        contentView.backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.layout {
            $0.top.equal(to: contentView.topAnchor)
            $0.bottom.equal(to: contentView.bottomAnchor)
            $0.leading.equal(to: contentView.leadingAnchor)
            $0.trailing.equal(to: contentView.trailingAnchor)
        }
        containerView.addSubview(checkImage)
        checkImage.layout {
            $0.trailing.equal(to: containerView.trailingAnchor, offsetBy: -20.0)
            $0.centerY.equal(to: containerView.centerYAnchor)
            $0.height.equal(to: 24.0)
            $0.width.equal(to: 24.0)
        }
        checkImage.image = .init(named: "checkIcon")
        
        containerView.addSubview(titleLabel)
        titleLabel.layout {
            $0.leading.equal(to: containerView.leadingAnchor, offsetBy: 16.0)
            $0.trailing.equal(to: checkImage.leadingAnchor, offsetBy: -4.0)
            $0.centerY.equal(to: containerView.centerYAnchor)
        }
        containerView.addSubview(borderLineView)
        borderLineView.layout {
            $0.trailing.equal(to: containerView.trailingAnchor)
            $0.leading.equal(to: containerView.leadingAnchor, offsetBy: 20.0)
            $0.bottom.equal(to: containerView.bottomAnchor)
            $0.height.equal(to: 1.0)
        }
        borderLineView.backgroundColor = .init(named: "cellLineColor")
    }
    
}


