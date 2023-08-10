//
//  MainItemObject.swift
//  GTAModes
//
//  Created by Максим Педько on 10.08.2023.
//

import Foundation
import RealmSwift

public struct MainItemsDataParser: Codable {
    
    public let data: [MainItemParser]
    
}

public struct MainItemParser: Codable {
    
    public let title: String
    public let type: String
    public let imagePath: String
    
}

public struct MainItem {
    
    public var title: String = ""
    public var type: String = ""
    public var imagePath: String = ""
    public var typeItem: MenuItemType
    
    init(title: String, type: String, imagePath: String, typeItem: MenuItemType) {
        self.title = title
        self.type = type
        self.imagePath = imagePath
        self.typeItem = typeItem
    }
    
}

public enum MenuItemType: String {
    
    case main, gameSelection
    
}

public final class MainItemObject: Object {

    @objc dynamic var title: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var imagePath: String = ""
    @objc dynamic var rawTypeItem: String = ""
    
    public var typeItem: MenuItemType {
        MenuItemType(rawValue: rawTypeItem) ?? .main
    }

    convenience init(
        title: String,
        type: String,
        imagePath: String,
        rawTypeItem: String
    ) {
        self.init()

        self.title = title
        self.type = type
        self.imagePath = imagePath
        self.rawTypeItem = rawTypeItem

    }

    var lightweightRepresentation: MainItem {
        return MainItem(title: title, type: type, imagePath: imagePath, typeItem: typeItem)
    }

}

