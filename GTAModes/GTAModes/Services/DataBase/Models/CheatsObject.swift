////
////  CheatsObject.swift
////  GTAModes
////
////  Created by Максим Педько on 10.08.2023.
////
import Foundation
import RealmSwift

struct CheatCodeParser: Codable {
    let name: String
    let code: [String]
    let filterTitle: String
}

struct CheatCodesPlatformParser: Codable {
    let ps: [CheatCodeParser]
    let xbox: [CheatCodeParser]
    let pc: [CheatCodeParser]?
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

public struct CheatItem {
    
    var name: String = ""
    var code: [String] = []
    var filterTitle: String = ""
    var platform: String = ""
    var game: String = ""
    var isFavorite: Bool = false
    
    init(name: String, code: [String], filterTitle: String, platform: String, game: String, isFavorite: Bool) {
        self.name = name
        self.code = code
        self.filterTitle = filterTitle
        self.platform = platform
        self.game = game
        self.isFavorite = isFavorite
    }
    
}

public final class CheatObject: Object {
    
    @objc dynamic private(set) var id: String = UUID().uuidString.lowercased()
    @objc dynamic var name: String = ""
    var code = List<String>()
    @objc dynamic var filterTitle: String = ""
    @objc dynamic var platform: String = ""
    @objc dynamic var game: String = ""
    @objc dynamic var isFavorite: Bool = false
    
    override public static func primaryKey() -> String? {
        return #keyPath(CheatObject.id)
    }

    convenience init(
        name: String,
        code: [String],
        filterTitle: String,
        platform: String,
        game: String,
        isFavorite: Bool
    ) {
        self.init()
        self.name = name
        self.code.append(objectsIn: code)
        self.filterTitle = filterTitle
        self.platform = platform
        self.game = game
        self.isFavorite = isFavorite
    }

    var lightweightRepresentation: CheatItem {
        return CheatItem(
            name: name,
            code: Array(code),
            filterTitle: filterTitle,
            platform: platform,
            game: game,
            isFavorite: isFavorite
        )
    }
    
}
