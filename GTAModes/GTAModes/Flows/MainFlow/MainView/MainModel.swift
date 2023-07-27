//
//  MainModel.swift
//  GTA Modes
//
//  Created by Максим Педько on 27.07.2023.
//

import Foundation

protocol MainModelNavigationHandler: AnyObject {

  func mainModelDidRequestToGameSelection(_ model: MainModel)

}

final class MainModel {
    
    private let navigationHandler: MainModelNavigationHandler
    
    init(
        navigationHandler: MainModelNavigationHandler
    ) {
        self.navigationHandler = navigationHandler
    }
    
    
}
