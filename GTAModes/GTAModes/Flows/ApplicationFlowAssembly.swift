//
//  ApplicationFlowAssembly.swift
//  GTA Modes
//
//  Created by Максим Педько on 27.07.2023.
//

import Foundation
import RealmSwift
import Swinject

final class ApplicationFlowAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(Realm.Configuration.self) { _ in
            return .defaultConfiguration
        }.inObjectScope(.container)
        

        container.register(Realm.self) { resolver in
            return Realm.forceCreate(with: resolver.autoresolve())
        }.inObjectScope(.transient)

    }
    
}
