//
//  ModObject.swift
//  GTAModes
//
//  Created by Максим Педько on 20.08.2023.
//

import Foundation
import RealmSwift

struct ModParser: Codable {
    let title: String
    let description: String
    let image: String
    let mod: String
    let filterTitle: String
}

struct GTA5Mods: Codable {
    let GTA5: [String: [ModParser]]
}

public struct ModItem {
    
    public var title: String = ""
    public var description: String = ""
    public var imagePath: String = ""
    public var modPath: String = ""
    public var filterTitle: String = ""
    
    init(title: String, description: String, imagePath: String, modPath: String, filterTitle: String) {
        self.title = title
        self.description = description
        self.imagePath = imagePath
        self.modPath = modPath
        self.filterTitle = filterTitle
    }
    
}

public final class ModObject: Object {

    @objc dynamic var titleMod: String = ""
    @objc dynamic var descriptionMod: String = ""
    @objc dynamic var imagePath: String = ""
    @objc dynamic var modPath: String = ""
    @objc dynamic var filterTitle: String = ""

    convenience init(
        titleMod: String,
        descriptionMod: String,
        imagePath: String,
        modPath: String,
        filterTitle: String
    ) {
        self.init()

        self.titleMod = titleMod
        self.descriptionMod = descriptionMod
        self.imagePath = imagePath
        self.modPath = modPath
        self.filterTitle = filterTitle

    }

    var lightweightRepresentation: ModItem {
        return ModItem(
            title: titleMod,
            description: descriptionMod,
            imagePath: imagePath,
            modPath: modPath,
            filterTitle: filterTitle
        )
    }

}
