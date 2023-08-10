//
//  MainModel.swift
//  GTA Modes
//
//  Created by Максим Педько on 27.07.2023.
//

import Foundation
import RealmSwift
import Combine

protocol MainModelNavigationHandler: AnyObject {
    
    func mainModelDidRequestToGameSelection(_ model: MainModel)
    func mainModelDidRequestToChecklist(_ model: MainModel)
    func mainModelDidRequestToMap(_ model: MainModel)
    
}

final class MainModel {
    
    var reloadData: AnyPublisher<Void, Never> {
      reloadDataSubject
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    var menuItems: [MainItem] = []
    
    private let navigationHandler: MainModelNavigationHandler
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    
    init(
        navigationHandler: MainModelNavigationHandler
    ) {
        self.navigationHandler = navigationHandler
        fetchData()
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
    
    func fetchData() {
        do {
            let realm = try Realm()
            let menuItem = realm.objects(MainItemObject.self).map { $0.lightweightRepresentation}
            menuItem.forEach { [weak self] value in
                guard let self = self else { return }
                
                self.menuItems.append(value)
            }
            reloadDataSubject.send()
        } catch {
            print("Error saving data to Realm: \(error)")
        }
    }
    
}
