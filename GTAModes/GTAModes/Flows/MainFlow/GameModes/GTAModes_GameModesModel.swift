//
//  GTAModes_GameModesModel.swift
//  GTAModes
//
//  Created by Максим Педько on 20.08.2023.
//

import Foundation
import RealmSwift
import Combine
import UIKit

protocol GameModesModelNavigationHandler: AnyObject {
    
    func gameModesModelDidRequestToFilter(
        _ model: GTAModes_GameModesModel,
        filterListData: FilterListData,
        selectedFilter: @escaping (String) -> ()
    )
    func gameModesModelDidRequestToBack(_ model: GTAModes_GameModesModel)
}

final class GTAModes_GameModesModel {
    
    var reloadData: AnyPublisher<Void, Never> {
        reloadDataSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    var modeItems: [ModItem] = []
    var title: String {
        "Mods Version 5"
    }
    private let navigationHandler: GameModesModelNavigationHandler
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    var allModeItems: [ModItem] = []
    private var filterSelected: String = ""
    private var searchText: String = ""
    
    
    init(
        navigationHandler: GameModesModelNavigationHandler
    ) {
        self.navigationHandler = navigationHandler
        gta_fetchData()
        showMods() 
    }
    
    func gta_backActionProceed() {
        navigationHandler.gameModesModelDidRequestToBack(self)
    }
//
    func gta_filterActionProceed() {
//        let filterList = allCheatItems.map { $0.filterTitle }
//        let uniqueList = Array(Set(filterList))
//        let filterListData = FilterListData(filterList: uniqueList, selectedItem: filterSelected)
//        navigationHandler.gameModesModelDidRequestToFilter(
//            self,
//            filterListData: filterListData) { [weak self] selectedFilter in
//                guard let self = self else { return }
//
//                self.filterSelected = selectedFilter
//                if selectedFilter.isEmpty {
//                    self.gta_showCheats(currentPlatform)
//                } else {
//                    let list = self.cheatItems.filter { $0.filterTitle == selectedFilter }
//                    self.cheatItems = list
//                }
//                self.reloadDataSubject.send()
//            }
    }
    
    func gta_fetchData() {
        allModeItems.removeAll()
        do {
            let realm = try Realm()
            let modes = realm.objects(ModObject.self)
            let modesList = modes.map { $0.lightweightRepresentation }
            
            modesList.forEach { [weak self] value in
                guard let self = self else { return }
                
                self.allModeItems.append(value)
            }
        } catch {
            print("Error saving data to Realm: \(error)")
        }
    }

    func showMods() {
        modeItems = allModeItems
        reloadDataSubject.send()
    }
    func gta_actionAt(index: Int) {
//        let selectedItem = cheatItems[index]
//        do {
//            let realm = try Realm()
//            try! realm.write {
//                if let existingCheatObject = realm.objects(CheatObject.self)
//                    .filter("platform == %@ AND game == %@ AND name == %@", selectedItem.platform, selectedItem.game, selectedItem.name).first {
//                    existingCheatObject.name = selectedItem.name
//                    existingCheatObject.code.removeAll()
//                    existingCheatObject.code.append(objectsIn: selectedItem.code)
//                    existingCheatObject.filterTitle = selectedItem.filterTitle
//                    existingCheatObject.platform = selectedItem.platform
//                    existingCheatObject.game = selectedItem.game
//                    existingCheatObject.isFavorite = !selectedItem.isFavorite
//                    realm.add(existingCheatObject, update: .modified)
//                }
//
//            }
//            gta_fetchData(version: versionGame)
//            cheatItems[index].isFavorite = !cheatItems[index].isFavorite
//            reloadDataSubject.send()
//        } catch {
//            print("Error saving data to Realm: \(error)")
//        }
    }
//
    func gta_searchAt(_ searchText: String) {
//        let filteredList = allCheatItems.filter { $0.name.lowercased().contains(searchText.lowercased())}
//        cheatItems = filteredList
//        self.searchText = searchText
//        if searchText.isEmpty {
//            gta_showCheats(currentPlatform)
//        }
//        reloadDataSubject.send()
//
    }
    
    func gta_searchDidCancel() {
        if searchText.isEmpty {
//            gta_showCheats(currentPlatform)
        }
    }
    
}

