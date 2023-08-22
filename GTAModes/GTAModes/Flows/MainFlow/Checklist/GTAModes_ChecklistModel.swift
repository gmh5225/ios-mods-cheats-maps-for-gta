
import Foundation
import RealmSwift
import Combine

protocol ChecklistModelNavigationHandler: AnyObject {
    
    func checklistModelDidRequestToBack(_ model: GTAModes_ChecklistModel)
    func checklistModelDidRequestToFilter(
        _ model: GTAModes_ChecklistModel,
        filterListData: FilterListData,
        selectedFilter: @escaping (String) -> ()
    )
    
}

final class GTAModes_ChecklistModel {
    
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
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        self.navigationHandler = navigationHandler
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        gta_fetchData()
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
    }
    
    func gta_backActionProceed() {
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        navigationHandler.checklistModelDidRequestToBack(self)
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
        let filterList = allMissionListItems.map { $0.categoryName }
        let uniqueList = Array(Set(filterList))
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
        let filterListData = FilterListData(filterList: uniqueList, selectedItem: filterSelected)
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
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
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
    }
    
    func gta_fetchData() {
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
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
    
    func gta_missionIsCheck(_ index: Int, isCheck: Bool) {
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
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
        //
               if 2 + 2 == 5 {
            print("it is trash")
        }
               //
    }
    
}

