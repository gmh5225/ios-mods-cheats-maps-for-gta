//
//  MainFlowCoordinator.swift
//  GTA Modes
//
//  Created by Максим Педько on 27.07.2023.
//

import Foundation
import UIKit

final class GTAModes_MainFlowCoordinator: NSObject, GTAModes_FlowCoordinator {
    
    private weak var rootViewController: UIViewController?
    private weak var panPresentedViewController: UIViewController?
    private weak var presentedViewController: UIViewController?
    
    
    override init() {
        super.init()
    }
    
    func gta_createFlow() -> UIViewController {
        let model = GTAModes_MainModel(navigationHandler: self as MainModelNavigationHandler)
        let controller = GTAModes_MainViewController(model: model)
        rootViewController = controller
        
        return controller
    }
    
}

extension GTAModes_MainFlowCoordinator: MainModelNavigationHandler {
    
    func mainModelDidRequestToMap(_ model: GTAModes_MainModel) {
        let controller = GTAModes_MapViewController(navigationHandler: self as MapNavigationHandler)
        presentedViewController = controller
        rootViewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func mainModelDidRequestToGameSelection(_ model: GTAModes_MainModel) {
        let model = GSModel(navigationHandler: self as GSModelNavigationHandler)
        let controller = GSViewController(model: model)
        presentedViewController = controller
        
        rootViewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func mainModelDidRequestToChecklist(_ model: GTAModes_MainModel) {
        let model = GTAModes_ChecklistModel(navigationHandler: self as ChecklistModelNavigationHandler)
        let controller = GTAModes_ChecklistViewController(model: model)
        presentedViewController = controller
        rootViewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension GTAModes_MainFlowCoordinator: GSModelNavigationHandler {

    func gsModelDidRequestToBack(_ model: GSModel) {
        presentedViewController?.navigationController?.popViewController(animated: true)
    }
    
    
    func gsModelDidRequestToGameModes(_ model: GSModel, gameVersion: String) {
        let model = GTAModes_GameModesModel(versionGame: gameVersion, navigationHandler: self as GameModesModelNavigationHandler)
        let controller = GTAModes_GameModesViewController(model: model)
        presentedViewController?.navigationController?.pushViewController(controller, animated: true)
    }

}

extension GTAModes_MainFlowCoordinator: ChecklistModelNavigationHandler {
    
    func checklistModelDidRequestToFilter(
        _ model: GTAModes_ChecklistModel,
        filterListData: FilterListData,
        selectedFilter: @escaping (String) -> ()
    ) {
        
        let controller = GTAModes_FilterViewController(
            filterListData: filterListData,
            selectedFilter: selectedFilter,
            navigationHandler: self as FilterNavigationHandler
        )
        presentedViewController?.gta_presentPan(controller)
        panPresentedViewController = controller
    }
    
    
    func checklistModelDidRequestToBack(_ model: GTAModes_ChecklistModel) {
        presentedViewController?.navigationController?.popViewController(animated: true)
    }
    
}

extension GTAModes_MainFlowCoordinator: GameModesModelNavigationHandler {
    
    func gameModesModelDidRequestToBack(_ model: GTAModes_GameModesModel) {
        presentedViewController?.navigationController?.popViewController(animated: true)
    }
    
    
    func gameModesModelDidRequestToFilter(
        _ model: GTAModes_GameModesModel,
        filterListData: FilterListData,
        selectedFilter: @escaping (String) -> ()
    ) {

        let controller = GTAModes_FilterViewController(
            filterListData: filterListData,
            selectedFilter: selectedFilter,
            navigationHandler: self as FilterNavigationHandler
        )
        presentedViewController?.gta_presentPan(controller)
        panPresentedViewController = controller
    }
    
}

extension GTAModes_MainFlowCoordinator: FilterNavigationHandler {
    
    func filterDidRequestToClose() {
        panPresentedViewController?.dismiss(animated: true)
    }
    
}

extension GTAModes_MainFlowCoordinator: MapNavigationHandler {
    
    func mapDidRequestToBack() {
        presentedViewController?.navigationController?.popViewController(animated: true)
    }
}
