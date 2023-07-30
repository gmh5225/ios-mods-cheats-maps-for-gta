//
//  GameModesModel.swift
//  GTAModes
//
//  Created by Максим Педько on 30.07.2023.
//

import Foundation

protocol GameModesModelNavigationHandler: AnyObject {

  func GameModesModelDidRequestToGameSelection(_ model: MainModel)

}

final class GameModesModel {
    
    let menuItems: [MainCellData] = [
        .init(title: "Version 6", imageUrl: "V6"),
        .init(title: "Version 5", imageUrl: "V5"),
        .init(title: "Version VC", imageUrl: "VVC"),
        .init(title: "Version SA", imageUrl: "VSA")
    ]
    
    private let navigationHandler: GameModesModelNavigationHandler
    
    init(
        navigationHandler: GameModesModelNavigationHandler
    ) {
        self.navigationHandler = navigationHandler
    }
    
    
}

