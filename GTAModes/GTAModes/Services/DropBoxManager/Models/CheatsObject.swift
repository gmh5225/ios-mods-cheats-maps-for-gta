//
//  CheatsObject.swift
//  GTAModes
//
//  Created by Максим Педько on 09.08.2023.
//

import Foundation

struct CheatCode: Codable {
    let name: String
    let code: [String]
    let filterTitle: String
}

struct CheatCodePlatform: Codable {
    let platform: String
    let cheatCodes: [CheatCode]
}
