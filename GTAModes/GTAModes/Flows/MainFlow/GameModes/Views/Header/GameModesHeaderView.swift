//
//  GameModesHeaderView.swift
//  GTAModes
//
//  Created by Максим Педько on 03.08.2023.
//

import Foundation
import UIKit

final class GameModesHeaderView: UITableViewHeaderFooterView, Reusable {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 10 // Необходимый вам отступ между кнопками
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var selectedButton: UIButton?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(stackView)
        stackView.layout {
            $0.leading.equal(to: contentView.leadingAnchor, offsetBy: 20.0)
            $0.trailing.equal(to: contentView.trailingAnchor, offsetBy: -20.0)
            $0.top.equal(to: contentView.topAnchor)
            $0.bottom.equal(to: contentView.bottomAnchor)
        }
        // Создаем и настраиваем кнопки
        let images = ["sony", "xbox", "win", "fav"]
        for imageName in images {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: imageName), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.withBorder()
            button.withCornerRadius(4.33)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            button.layout {
                $0.height.equal(to: 79.0)
                $0.width.equal(to: 79.0)
            }
        }
    }
    
    @objc func buttonTapped(sender: UIButton) {
        if let index = stackView.arrangedSubviews.firstIndex(of: sender) {
            print("Button at index \(index) tapped.")
            if let selectedButton = selectedButton {
                selectedButton.backgroundColor = .clear
            }
            
            // Устанавливаем новую выбранную кнопку и изменяем ее цвет фона
            selectedButton = sender
            sender.backgroundColor = UIColor(named: "blueColor")?.withAlphaComponent(0.4)
        }
    }
}
