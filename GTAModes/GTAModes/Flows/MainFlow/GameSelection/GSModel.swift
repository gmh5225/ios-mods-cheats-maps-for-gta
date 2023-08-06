//
//  GSModel.swift
//  GTAModes
//
//  Created by Максим Педько on 29.07.2023.
//

import Foundation

protocol GSModelNavigationHandler: AnyObject {

  func gsModelDidRequestToGameModes(_ model: GSModel)

}

final class GSModel {
    
    let menuItems: [MainCellData] = [
        .init(title: "Version 6", imageUrl: "V6"),
        .init(title: "Version 5", imageUrl: "V5"),
        .init(title: "Version VC", imageUrl: "VVC"),
        .init(title: "Version SA", imageUrl: "VSA")
    ]
    
    private let navigationHandler: GSModelNavigationHandler
    
    init(
        navigationHandler: GSModelNavigationHandler
    ) {
        self.navigationHandler = navigationHandler
    }
    
    public func selectedItems(index: Int) {
        if index == 0 {
            navigationHandler.gsModelDidRequestToGameModes(self)
        }
        
       
    }
    
}

