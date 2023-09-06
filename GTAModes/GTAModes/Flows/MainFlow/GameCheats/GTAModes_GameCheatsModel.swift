
import Foundation
import RealmSwift
import Combine
import UIKit

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

protocol GameCheatsModelNavigationHandler: AnyObject {
    
    func gameModesModelDidRequestToFilter(
        _ model: GTAModes_GameCheatsModel,
        filterListData: FilterListData,
        selectedFilter: @escaping (String) -> ()
    )
    func gameModesModelDidRequestToBack(_ model: GTAModes_GameCheatsModel)
}

final class GTAModes_GameCheatsModel {
    
    public var hideSpiner: (() -> Void)?
    
    var reloadData: AnyPublisher<Void, Never> {
        reloadDataSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    var cheatItems: [CheatItem] = []
    var title: String {
        versionGame
    }
    private let navigationHandler: GameCheatsModelNavigationHandler
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    private let versionGame: String
    var allCheatItems: [CheatItem] = []
    private var filterSelected: String = ""
    private var currentPlatform: CheatsType
    private var searchText: String = ""
    private let defaults = UserDefaults.standard
    
    
    init(
        versionGame: String,
        navigationHandler: GameCheatsModelNavigationHandler
    ) {
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        self.versionGame = versionGame
        self.navigationHandler = navigationHandler
        self.currentPlatform = .ps
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        
        GTAModes_DBManager.shared.delegate = self
        if let isLoadedData = defaults.value(forKey: "gta_isReadyGameCodes") as? Bool, isLoadedData {
            gta_fetchData(version: versionGame)
            gta_showCheats(.ps)
        }
        
    }
    
    func gta_backActionProceed() {
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        navigationHandler.gameModesModelDidRequestToBack(self)
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
    }
    
    func gta_filterActionProceed() {
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        let filterList = allCheatItems.map { $0.filterTitle }
        let uniqueList = Array(Set(filterList)).sorted()
//        let sortedList = u
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        let filterListData = FilterListData(filterList: uniqueList, selectedItem: filterSelected)
        navigationHandler.gameModesModelDidRequestToFilter(
            self,
            filterListData: filterListData) { [weak self] selectedFilter in
                guard let self = self else { return }
                
                self.filterSelected = selectedFilter
//                if selectedFilter.isEmpty {
                    self.gta_fetchData(version: self.versionGame)
                    self.gta_showCheats(currentPlatform)
//                } else {
//                    let list = self.cheatItems.filter { $0.filterTitle == selectedFilter }
//                    self.cheatItems = list
//                }
                self.reloadDataSubject.send()
            }
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
    }
    
    func gta_fetchData(version: String) {
        allCheatItems.removeAll()
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
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
    
    func gta_showCheats(_ type: CheatsType) {
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
           gta_fetchData(version: versionGame)
        
        var list: [CheatItem] = []
        currentPlatform = type
        switch type {
        case .ps:
            list = allCheatItems.filter { $0.platform == "ps" }
            
        case .xbox:
            list = allCheatItems.filter { $0.platform == "xbox" }
            
        case .pc:
            list = allCheatItems.filter { $0.platform == "pc" }
            
        case .favorite:
            list = allCheatItems.filter { $0.isFavorite == true }
        }
        
        if !filterSelected.isEmpty {
            let listFiltered = list.filter { $0.filterTitle == filterSelected }
            self.cheatItems = listFiltered
        } else {
            cheatItems = list
        }
        reloadDataSubject.send()
        hideSpiner?()
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
    }
    
    func gta_actionAt(index: Int) {
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
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
            gta_showCheats(currentPlatform)
            reloadDataSubject.send()
        } catch {
            print("Error saving data to Realm: \(error)")
        }
    }
    
    func gta_searchAt(_ searchText: String) {
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        let filteredList = allCheatItems.filter { $0.name.lowercased().contains(searchText.lowercased())}
        cheatItems = filteredList
        self.searchText = searchText
        if searchText.isEmpty {
            gta_showCheats(currentPlatform)
        }
        reloadDataSubject.send()
        
    }
    
    func gta_searchDidCancel() {
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        if searchText.isEmpty {
            gta_showCheats(currentPlatform)
        }
    }
    
}

extension GTAModes_GameCheatsModel: GTA_DropBoxManagerDelegate {
    
    func gta_isReadyMain() {}
    
    func gta_isReadyGameList() {
        
    }
    
    func gta_isReadyGameCodes() {
        gta_fetchData(version: versionGame)
        gta_showCheats(.ps)
    }
    
    func gta_isReadyMissions() { }
    
    func gta_isReadyGTA5Mods() { }
    
    
}
