////
////  CheatsObject.swift
////  GTAModes
////
////  Created by Максим Педько on 10.08.2023.
////
import Foundation

struct CheatCodeParser: Codable {
    let name: String
    let code: [String]
    let filterTitle: String
}

struct CheatCodesPlatformParser: Codable {
    let ps: [CheatCodeParser]
    let xbox: [CheatCodeParser]
    let pc: [CheatCodeParser]
}

struct CheatCodesGTA5Parser: Codable {
    let GTA5: CheatCodesPlatformParser
}

struct CheatCodesGTA6Parser: Codable {
    let GTA6: CheatCodesPlatformParser
}

struct CheatCodesGTASAParser: Codable {
    let GTA_San_Andreas: CheatCodesPlatformParser
}

struct CheatCodesGTAVCParser: Codable {
    let GTA_Vice_City: CheatCodesPlatformParser
}
