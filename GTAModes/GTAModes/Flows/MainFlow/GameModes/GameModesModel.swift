//
//  GameModesModel.swift
//  GTAModes
//
//  Created by Максим Педько on 30.07.2023.
//

import Foundation

protocol GameModesModelNavigationHandler: AnyObject {

  func gameModesModelDidRequestToGameSelection(_ model: GameModesModel)
    func gameModesModelDidRequestToFilter(_ model: GameModesModel)
}

final class GameModesModel {
    
    let dataItems: [GameModesData] = [
        .init(
            title: "The Good Husband",
            imageNames: ["s_circle", "s_r1", "s_l2", "s_up", "s_cross", "s_left"],
            isFavorite: Bool.random())
    ]
    
    private let navigationHandler: GameModesModelNavigationHandler
    
    init(
        navigationHandler: GameModesModelNavigationHandler
    ) {
        self.navigationHandler = navigationHandler
    }
    
    func backActionProceed() {
        
    }
    
    func filterActionProceed() {
        navigationHandler.gameModesModelDidRequestToFilter(self)
    }
    
    
}

