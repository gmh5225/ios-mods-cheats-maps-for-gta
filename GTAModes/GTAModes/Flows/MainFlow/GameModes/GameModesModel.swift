//
//  GameModesModel.swift
//  GTAModes
//
//  Created by Максим Педько on 30.07.2023.
//

import Foundation
import RealmSwift
import Combine

public enum CheatsType: CaseIterable {
    case ps, xbox, pc, favorite
}

public struct FilterListData {
    
    public let filterList: [String]
    public let selectedItem: String
    
    init(filterList: [String], selectedItem: String) {
        self.filterList = filterList
        self.selectedItem = selectedItem
    }
    
}

protocol GameModesModelNavigationHandler: AnyObject {
    
    func gameModesModelDidRequestToGameSelection(_ model: GameModesModel)
    func gameModesModelDidRequestToFilter(
        _ model: GameModesModel,
        filterListData: FilterListData,
        selectedFilter: @escaping (String) -> ()
    )
    func gameModesModelDidRequestToBack(_ model: GameModesModel)
}

final class GameModesModel {
    
    var reloadData: AnyPublisher<Void, Never> {
        reloadDataSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    var cheatItems: [CheatItem] = []
    var title: String {
        versionGame
    }
    private let navigationHandler: GameModesModelNavigationHandler
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    private let versionGame: String
    var allCheatItems: [CheatItem] = []
    private var filterSelected: String = ""
    
    
    init(
        versionGame: String,
        navigationHandler: GameModesModelNavigationHandler
    ) {
        self.versionGame = versionGame
        self.navigationHandler = navigationHandler
        self.fetchData(version: versionGame)
        self.showCheats(.ps)
    }
    
    func backActionProceed() {
        navigationHandler.gameModesModelDidRequestToBack(self)
    }
    
    func filterActionProceed() {
        let filterList = allCheatItems.map { $0.filterTitle }
        let uniqueList = Array(Set(filterList))
        let filterListData = FilterListData(filterList: uniqueList, selectedItem: filterSelected)
        navigationHandler.gameModesModelDidRequestToFilter(
            self,
            filterListData: filterListData) { [weak self] selectedFilter in
                guard let self = self else { return }
                
                self.filterSelected = selectedFilter
                let list = self.allCheatItems.filter { $0.filterTitle == selectedFilter }
                self.cheatItems = list
                self.reloadDataSubject.send()
            }
    }
    
    func fetchData(version: String) {
        allCheatItems.removeAll()
        do {
            let realm = try Realm()
            let cheats = realm.objects(CheatObject.self)
            let cheatsList = cheats.filter { $0.game == version }
            let cheatsValueList = cheatsList.map { $0.lightweightRepresentation }
            
            cheatsValueList.forEach { [weak self] value in
                guard let self = self else { return }
                
                self.allCheatItems.append(value)
            }
        } catch {
            print("Error saving data to Realm: \(error)")
        }
    }
    
    func showCheats(_ type: CheatsType) {
        switch type {
        case .ps:
            let list = allCheatItems.filter { $0.platform == "ps" }
            cheatItems = list
            reloadDataSubject.send()
        case .xbox:
            let list = allCheatItems.filter { $0.platform == "xbox" }
            cheatItems = list
            reloadDataSubject.send()
        case .pc:
            let list = allCheatItems.filter { $0.platform == "pc" }
            cheatItems = list
            reloadDataSubject.send()
        case .favorite:
            let list = allCheatItems.filter { $0.isFavorite == true }
            cheatItems = list
            reloadDataSubject.send()
        }
    }
    
    func actionAt(index: Int) {
        let selectedItem = cheatItems[index]
        do {
            let realm = try Realm()
            try! realm.write {
                if let existingCheatObject = realm.objects(CheatObject.self)
                    .filter("platform == %@ AND game == %@ AND name == %@", selectedItem.platform, selectedItem.game, selectedItem.name).first {
                    existingCheatObject.name = selectedItem.name
                    existingCheatObject.code.removeAll()
                    existingCheatObject.code.append(objectsIn: selectedItem.code)
                    existingCheatObject.filterTitle = selectedItem.filterTitle
                    existingCheatObject.platform = selectedItem.platform
                    existingCheatObject.game = selectedItem.game
                    existingCheatObject.isFavorite = !selectedItem.isFavorite
                    realm.add(existingCheatObject, update: .modified)
                }
                    
            }
            fetchData(version: versionGame)
            cheatItems[index].isFavorite = !cheatItems[index].isFavorite
            reloadDataSubject.send()
        } catch {
            print("Error saving data to Realm: \(error)")
        }
    }
    
}

