//
//  ModObject.swift
//  GTAModes
//
//  Created by Максим Педько on 20.08.2023.
//

import Foundation

struct Mod: Codable {
    let title: String
    let description: String
    let image: String
    let mod: String
    let filterTitle: String
}

struct GTA5Mods: Codable {
    let GTA5: [String: [Mod]]
}
