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
    
    func mainModelDidRequestToGameSelection(_ model: GTAModes_MainModel)
    func mainModelDidRequestToChecklist(_ model: GTAModes_MainModel)
    func mainModelDidRequestToMap(_ model: GTAModes_MainModel)
    func mainModelDidRequestToModes(_ model: GTAModes_MainModel)
    
}

final class GTAModes_MainModel {
    
    public var hideSpiner: (() -> Void)?
    
    var reloadData: AnyPublisher<Void, Never> {
        reloadDataSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    var menuItems: [MainItem] = []
    
    private let navigationHandler: MainModelNavigationHandler
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    private let defaults = UserDefaults.standard
    var notificationToken: NotificationToken?
    
    init(
        navigationHandler: MainModelNavigationHandler
    ) {
        self.navigationHandler = navigationHandler
        
        GTAModes_DBManager.shared.delegate = self
        GTAModes_DBManager.shared.gta_setupDropBox()
    }
    
    public func gta_selectedItems(index: Int) {
        if index == 0 {
            navigationHandler.mainModelDidRequestToGameSelection(self)
        }
        
        if index == 1 {
            navigationHandler.mainModelDidRequestToChecklist(self)
        }
        
        if index == 2 {
            navigationHandler.mainModelDidRequestToMap(self)
        }
        
        if index == 3 {
            navigationHandler.mainModelDidRequestToModes(self)
        }
    }

    func gta_fetchData() {
        if menuItems.count != 4 {
            do {
                let realm = try Realm()
                let menuItem = realm.objects(MainItemObject.self)
                let valueList = menuItem.filter { $0.rawTypeItem == "main"}
                let trueValueList = valueList.map { $0.lightweightRepresentation }
                
                trueValueList.forEach { [weak self] value in
                    guard let self = self else { return }
                    
                    self.menuItems.append(value)
                }
                reloadDataSubject.send()
                hideSpiner?()
            } catch {
                print("Error saving data to Realm: \(error)")
            }
        }
    }
    
}

extension GTAModes_MainModel: GTA_DropBoxManagerDelegate {
    
    func gta_currentProgressOperation(progress: Progress) {
        print("OK")
    }
    
    func gta_isReadyAllContent() {
        gta_fetchData()
    }
    
}
