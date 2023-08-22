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
    var showSpinnerData: AnyPublisher<Bool, Never> {
        showSpinnerSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    var modeItems: [ModItem] = []
    var title: String {
        "Mods Version 5"
    }
    private let navigationHandler: GameModesModelNavigationHandler
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    private let showSpinnerSubject = PassthroughSubject<Bool, Never>()
    var allModeItems: [ModItem] = []
    private var filterSelected: String = ""
    private var searchText: String = ""
    
    
    init(
        navigationHandler: GameModesModelNavigationHandler
    ) {
        self.navigationHandler = navigationHandler
        gta_fetchData()
        showMods()
        GTAModes_DBManager.shared.delegate = self
    }
    
    func gta_backActionProceed() {
        navigationHandler.gameModesModelDidRequestToBack(self)
    }
    
    func gta_filterActionProceed() {
        let filterList = allModeItems.map { $0.filterTitle }
        let uniqueList = Array(Set(filterList))
        let filterListData = FilterListData(filterList: uniqueList, selectedItem: filterSelected)
        navigationHandler.gameModesModelDidRequestToFilter(
            self,
            filterListData: filterListData) { [weak self] selectedFilter in
                guard let self = self else { return }

                self.filterSelected = selectedFilter
                if selectedFilter.isEmpty {
                    self.modeItems = allModeItems
                } else {
                    let list = self.allModeItems.filter { $0.filterTitle == selectedFilter }
                    self.modeItems = list
                }
                self.reloadDataSubject.send()
            }
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
    
    func downloadMode(index: Int) {
        let mode = modeItems[index]
        showSpinnerSubject.send(true)
        if !checkIsLoadData(mode.title) {
            GTAModes_DBManager.shared.downloadMode(mode: mode) { [weak self] localUrl in
                if let localUrl = localUrl {
                    print("File downloaded to: \(localUrl)")
                    self?.showSpinnerSubject.send(false)
                    self?.reloadDataSubject.send()
                } else {
                    self?.showSpinnerSubject.send(false)
                    self?.reloadDataSubject.send()
                    print("ERROR")
                }
                
            }
        } else {
            showSpinnerSubject.send(false)
            reloadDataSubject.send()
            print("FILE IS LOCALY")
        }
        
    }
    
    func checkIsLoadData(_ modeName: String) -> Bool {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(modeName)
        
        return FileManager.default.fileExists(atPath: fileURL.path)
    }

    func showMods() {
        modeItems = allModeItems
        reloadDataSubject.send()
    }
    
    func gta_searchAt(_ searchText: String) {
        let filteredList = allModeItems.filter { $0.title.lowercased().contains(searchText.lowercased())}
        modeItems = filteredList
        self.searchText = searchText
        if searchText.isEmpty {
            modeItems = allModeItems
        }
        reloadDataSubject.send()
    }
    
    func gta_searchDidCancel() {
        if searchText.isEmpty {
            modeItems = allModeItems
        }
    }
    
}

extension GTAModes_GameModesModel: GTA_DropBoxManagerDelegate {
    
    func gta_currentProgressOperation(progress: Progress) {
        print("OK")
    }
    
    func gta_isReadyAllContent() {
        print("OK")
    }
    
}
