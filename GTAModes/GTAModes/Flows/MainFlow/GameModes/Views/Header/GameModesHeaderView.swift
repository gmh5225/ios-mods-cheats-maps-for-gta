//
//  GameModesHeaderView.swift
//  GTAModes
//
//  Created by Максим Педько on 03.08.2023.
//

import Foundation
import UIKit

final class GameModesHeaderView: UITableViewHeaderFooterView, Reusable {
  
  static let height = 32.0
  
  private let titleLabel = UILabel()
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setTitle(_ title: NSAttributedString) {
    titleLabel.attributedText = title
  }
  
  private func setupView() {
    titleLabel.accessibilityIdentifier = "titleLabel"
    contentView.addSubviews(titleLabel)
    titleLabel.layout {
      $0.centerY.equal(to: centerYAnchor)
      $0.leading.equal(to: contentView.leadingAnchor, offsetBy: .layoutMargin2x)
    }
  }
  
}
