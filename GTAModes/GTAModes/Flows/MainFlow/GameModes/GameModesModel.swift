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

protocol GameModesModelNavigationHandler: AnyObject {
    
    func gameModesModelDidRequestToGameSelection(_ model: GameModesModel)
    func gameModesModelDidRequestToFilter(_ model: GameModesModel)
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
    
    init(
        versionGame: String,
        navigationHandler: GameModesModelNavigationHandler
    ) {
        self.versionGame = versionGame
        self.navigationHandler = navigationHandler
        fetchData(version: versionGame)
    }
    
    func backActionProceed() {
        navigationHandler.gameModesModelDidRequestToBack(self)
    }
    
    func filterActionProceed() {
        navigationHandler.gameModesModelDidRequestToFilter(self)
    }
    
    func fetchData(version: String) {
        do {
            let realm = try Realm()
            let cheats = realm.objects(CheatObject.self)
            let cheatsList = cheats.filter { $0.game == version }
            let cheatsValueList = cheatsList.map { $0.lightweightRepresentation }
            
            cheatsValueList.forEach { [weak self] value in
                guard let self = self else { return }
                
                self.allCheatItems.append(value)
            }
            showCheats(.ps)
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
    
}

