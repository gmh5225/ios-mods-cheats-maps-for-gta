//
//  MainFlowCoordinator.swift
//  GTA Modes
//
//  Created by Максим Педько on 27.07.2023.
//

import Foundation
import UIKit

final class MainFlowCoordinator: NSObject, FlowCoordinator {
    
    private weak var rootViewController: UIViewController?
    private weak var panPresentedViewController: UIViewController?
    private weak var presentedViewController: UIViewController?
    
    //    private var container: Container!
    
    override init() {
        super.init()
    }
    
    func createFlow() -> UIViewController {
        let model = MainModel(navigationHandler: self as MainModelNavigationHandler)
        let controller = MainViewController(model: model)
        rootViewController = controller
        
        return controller
    }
    
}

extension MainFlowCoordinator: MainModelNavigationHandler {
    
    func mainModelDidRequestToMap(_ model: MainModel) {
        let controller = MapViewController(navigationHandler: self as MapNavigationHandler)
        presentedViewController = controller
        rootViewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func mainModelDidRequestToGameSelection(_ model: MainModel) {
        let model = GSModel(navigationHandler: self as GSModelNavigationHandler)
        let controller = GSViewController(model: model)
        presentedViewController = controller
        
        rootViewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func mainModelDidRequestToChecklist(_ model: MainModel) {
        let model = ChecklistModel(navigationHandler: self as ChecklistModelNavigationHandler)
        let controller = ChecklistViewController(model: model)
        presentedViewController = controller
        rootViewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension MainFlowCoordinator: GSModelNavigationHandler {

    func gsModelDidRequestToBack(_ model: GSModel) {
        presentedViewController?.navigationController?.popViewController(animated: true)
    }
    
    
    func gsModelDidRequestToGameModes(_ model: GSModel, gameVersion: String) {
        let model = GameModesModel(versionGame: gameVersion, navigationHandler: self as GameModesModelNavigationHandler)
        let controller = GameModesViewController(model: model)
        presentedViewController?.navigationController?.pushViewController(controller, animated: true)
    }

}

extension MainFlowCoordinator: ChecklistModelNavigationHandler {
    
    func checklistModelDidRequestToFilter(
        _ model: ChecklistModel,
        filterListData: FilterListData,
        selectedFilter: @escaping (String) -> ()
    ) {
        
        let controller = FilterViewController(
            filterListData: filterListData,
            selectedFilter: selectedFilter,
            navigationHandler: self as FilterNavigationHandler
        )
        presentedViewController?.presentPan(controller)
        panPresentedViewController = controller
    }
    
    
    func checklistModelDidRequestToBack(_ model: ChecklistModel) {
        presentedViewController?.navigationController?.popViewController(animated: true)
    }
    
}

extension MainFlowCoordinator: GameModesModelNavigationHandler {
    
    func gameModesModelDidRequestToBack(_ model: GameModesModel) {
        presentedViewController?.navigationController?.popViewController(animated: true)
    }
    
    
    func gameModesModelDidRequestToFilter(
        _ model: GameModesModel,
        filterListData: FilterListData,
        selectedFilter: @escaping (String) -> ()
    ) {

        let controller = FilterViewController(
            filterListData: filterListData,
            selectedFilter: selectedFilter,
            navigationHandler: self as FilterNavigationHandler
        )
        presentedViewController?.presentPan(controller)
        panPresentedViewController = controller
    }
    
}

extension MainFlowCoordinator: FilterNavigationHandler {
    
    func filterDidRequestToClose() {
        panPresentedViewController?.dismiss(animated: true)
    }
    
}

extension MainFlowCoordinator: MapNavigationHandler {
    
    func mapDidRequestToBack() {
        presentedViewController?.navigationController?.popViewController(animated: true)
    }
}
