//
//  GSModel.swift
//  GTAModes
//
//  Created by Максим Педько on 29.07.2023.
//

import Foundation
import Combine
import RealmSwift

public enum GameSelected: String, CaseIterable {
    
    case gta6 = "GTA6"
    case gta5 = "GTA5"
    case gtaVC = "GTAVC"
    case gtaSA = "GTASA"
    
}

protocol GSModelNavigationHandler: AnyObject {
    
    func gsModelDidRequestToGameModes(_ model: GSModel, gameVersion: String)
    func gsModelDidRequestToBack(_ model: GSModel)
    
}

final class GSModel {
    
    var reloadData: AnyPublisher<Void, Never> {
      reloadDataSubject
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    var menuItems: [MainItem] = []
    
    private let navigationHandler: GSModelNavigationHandler
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    
    init(
        navigationHandler: GSModelNavigationHandler
    ) {
        self.navigationHandler = navigationHandler
        gta_fetchData()
    }
    
    public func gta_selectedItems(index: Int) {
        
        navigationHandler.gsModelDidRequestToGameModes(
            self,
            gameVersion: GameSelected.allCases[index].rawValue
        )
    }
    
    public func gta_backActionProceed() {
        //
        navigationHandler.gsModelDidRequestToBack(self)
        //
    }
    
    func gta_fetchData() {
        do {
            let realm = try Realm()
            let menuItem = realm.objects(MainItemObject.self)
            let valueList = menuItem.filter { $0.rawTypeItem == "gameList"}
            let trueValueList = valueList.map { $0.lightweightRepresentation }
            
            trueValueList.forEach { [weak self] value in
                guard let self = self else { return }
                
                self.menuItems.append(value)
            }
            reloadDataSubject.send()
        } catch {
            print("Error saving data to Realm: \(error)")
        }
    }
    
}

