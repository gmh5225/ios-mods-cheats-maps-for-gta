//
//  ChecklistModel.swift
//  GTAModes
//
//  Created by Максим Педько on 30.07.2023.
//

import Foundation
import RealmSwift
import Combine

protocol ChecklistModelNavigationHandler: AnyObject {
    
    func checklistModelDidRequestToBack(_ model: ChecklistModel)
    func checklistModelDidRequestToFilter(
        _ model: ChecklistModel,
        filterListData: FilterListData,
        selectedFilter: @escaping (String) -> ()
    )
    
}

final class ChecklistModel {
    
    var missionList: [MissionItem] = []
    var reloadData: AnyPublisher<Void, Never> {
        reloadDataSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private var filterSelected: String = ""
    private let navigationHandler: ChecklistModelNavigationHandler
    private let reloadDataSubject = PassthroughSubject<Void, Never>()
    private var filteredItems: [MissionItem] = []
    private var allMissionListItems: [MissionItem] = []
    
    init(
        navigationHandler: ChecklistModelNavigationHandler
    ) {
        self.navigationHandler = navigationHandler
        fetchData()
    }
    
    func backActionProceed() {
        navigationHandler.checklistModelDidRequestToBack(self)
    }
    
    func filterActionProceed() {
        let filterList = missionList.map { $0.categoryName }
        let uniqueList = Array(Set(filterList))
        let filterListData = FilterListData(filterList: uniqueList, selectedItem: filterSelected)
        
        navigationHandler.checklistModelDidRequestToFilter(
            self,
            filterListData: filterListData) { [weak self] selectedFilter in
                guard let self = self else { return }
                
                self.filterSelected = selectedFilter
                if selectedFilter.isEmpty {
                    self.missionList = allMissionListItems
                } else {
                    let list = self.allMissionListItems.filter { $0.categoryName == selectedFilter }
                    self.missionList = list
                }
                self.reloadDataSubject.send()
            }
    }
    
    func fetchData() {
        do {
            let realm = try Realm()
            let missionsItem = realm.objects(MissionObject.self)
            let valueList = missionsItem.map { $0.lightweightRepresentation}
            
            valueList.forEach { [weak self] value in
                guard let self = self else { return }
                
                self.missionList.append(value)
            }
            allMissionListItems = missionList
            reloadDataSubject.send()
        } catch {
            print("Error saving data to Realm: \(error)")
        }
    }
    
    func missionIsCheck(_ index: Int, isCheck: Bool) {
        let selectedItem = missionList[index]
        do {
            let realm = try Realm()
            try! realm.write {
                if let existingMissionObject = realm.objects(MissionObject.self)
                    .filter("name == %@ AND category == %@", selectedItem.missionName, selectedItem.categoryName).first {
                    existingMissionObject.name = selectedItem.missionName
                    existingMissionObject.category = selectedItem.categoryName
                    existingMissionObject.isCheck = !selectedItem.isCheck
                    realm.add(existingMissionObject, update: .modified)
                }
                
            }
            missionList[index].isCheck = !missionList[index].isCheck
            reloadDataSubject.send()
        } catch {
            print("Error saving data to Realm: \(error)")
        }
    }
    
}

