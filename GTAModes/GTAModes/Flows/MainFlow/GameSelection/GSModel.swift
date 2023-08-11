//
//  GSModel.swift
//  GTAModes
//
//  Created by Максим Педько on 29.07.2023.
//

import Foundation
import Combine
import RealmSwift

protocol GSModelNavigationHandler: AnyObject {
    
    func gsModelDidRequestToGameModes(_ model: GSModel)
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
        fetchData()
    }
    
    public func selectedItems(index: Int) {
        if index == 0 {
            navigationHandler.gsModelDidRequestToGameModes(self)
        }
    }
    
    public func backActionProceed() {
        navigationHandler.gsModelDidRequestToBack(self)
    }
    
    func fetchData() {
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

