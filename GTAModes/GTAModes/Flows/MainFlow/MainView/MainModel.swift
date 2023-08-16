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
    private let defaults = UserDefaults.standard
    var notificationToken: NotificationToken?
    private let reachability = Reachability()
    
    init(
        navigationHandler: MainModelNavigationHandler
    ) {
        self.navigationHandler = navigationHandler
        listenNetworkConnection()
        if let isLoadedData = defaults.value(forKey: "dataDidLoaded") as? Bool, isLoadedData {
            fetchData()
        }
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
        if menuItems.count != 3 {
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
            } catch {
                print("Error saving data to Realm: \(error)")
            }
        }
    }
    
    private func listenNetworkConnection() {
        guard let statusInternet = reachability?.networkReachabilityStatus else { return }
        switch statusInternet {
        case .notReachable:
            print("NOT INTERNET")
        case .reachable(_, _):
            print("YESSSS INTERNET")
        case .unknown:
            print("WTF INTERNET")
        }
        
        reachability?.listener = { [weak self] status in
            print(status)
        }
        reachability?.startListening()
    }
}

extension MainModel: DropBoxManagerDelegate {
    
    func isReadyMainContent() {
        print("OK")
    }
    
    
    func currentProgressOperation(progress: Progress) {
        print("OK")
    }
    
    func isReadyAllContent() {
        fetchData()
    }
    
}
