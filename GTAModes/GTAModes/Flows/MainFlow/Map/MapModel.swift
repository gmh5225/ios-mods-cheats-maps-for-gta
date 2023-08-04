//
//  MapModel.swift
//  GTAModes
//
//  Created by Максим Педько on 01.08.2023.
//

import Foundation

protocol MapModelNavigationHandler: AnyObject {

  func mapModelDidRequestToGameSelection(_ model: MainModel)

}

final class MapModel {
    
    
    private let navigationHandler: MapModelNavigationHandler
    
    init(
        navigationHandler: MapModelNavigationHandler
    ) {
        self.navigationHandler = navigationHandler
    }
    
//    func getLocalMap() -> URL {
//        
//    }
    
}

