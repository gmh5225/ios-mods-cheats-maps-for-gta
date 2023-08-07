//
//  ChecklistModel.swift
//  GTAModes
//
//  Created by Максим Педько on 30.07.2023.
//

import Foundation

protocol ChecklistModelNavigationHandler: AnyObject {

  func checklistModelDidRequestToBack(_ model: ChecklistModel)
  func checklistModelDidRequestToFilter(_ model: ChecklistModel)

}

final class ChecklistModel {
    
    let menuItems: [ChecklistData] = [
        .init(title: "Version 6", type: "V6", isOn: Bool.random()),
        .init(title: "Version 5", type: "V5", isOn: Bool.random()),
        .init(title: "Version VC", type: "VVC", isOn: Bool.random()),
        .init(title: "Version SA", type: "VSA", isOn: Bool.random())
    ]
    
    private let navigationHandler: ChecklistModelNavigationHandler
    
    init(
        navigationHandler: ChecklistModelNavigationHandler
    ) {
        self.navigationHandler = navigationHandler
    }
    
    func backActionProceed() {
        navigationHandler.checklistModelDidRequestToBack(self)
    }
    
    func filterActionProceed() {
        navigationHandler.checklistModelDidRequestToFilter(self)
    }
    
}

