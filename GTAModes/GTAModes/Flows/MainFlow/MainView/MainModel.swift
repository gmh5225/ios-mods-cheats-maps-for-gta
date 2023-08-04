//
//  MainModel.swift
//  GTA Modes
//
//  Created by Максим Педько on 27.07.2023.
//

import Foundation

protocol MainModelNavigationHandler: AnyObject {

  func mainModelDidRequestToGameSelection(_ model: MainModel)
  func mainModelDidRequestToChecklist(_ model: MainModel)
    func mainModelDidRequestToMap(_ model: MainModel)
    
}

final class MainModel {
    
    let menuItems: [MainCellData] = [
        .init(title: "Cheats", imageUrl: "mainCell1"),
        .init(title: "Checklist", imageUrl: "mainCell2"),
        .init(title: "Map", imageUrl: "mainCell3")
    ]
    
    private let navigationHandler: MainModelNavigationHandler
    
    init(
        navigationHandler: MainModelNavigationHandler
    ) {
        self.navigationHandler = navigationHandler
    }
    
    public func selectedItems(index: Int) {
        if index == 0 {
            navigationHandler.mainModelDidRequestToGameSelection(self)
        }
        
        if index == 1 {
            navigationHandler.mainModelDidRequestToChecklist(self)
        }
        
        if index == 2 {
            navigationHandler.mainModelDidRequestToMap(self)
        }
    }
    
}
