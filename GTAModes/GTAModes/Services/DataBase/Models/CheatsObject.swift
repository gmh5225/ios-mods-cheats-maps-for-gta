////
////  CheatsObject.swift
////  GTAModes
////
////  Created by Максим Педько on 10.08.2023.
////
//
//import Foundation
//import RealmSwift
//
//public struct CheatCode: Codable {
//    public let name: String
//    public let code: [String]
//    public let filterTitle: String
//}
//
//public struct CheatCodePlatform: Codable {
//    public let platform: String
//    public let cheatCodes: [CheatCode]
//    
//}
//
//public final class CheatObject: Object {
//    
//    @objc dynamic var platform: String
//    @objc dynamic var name: String
//    @objc dynamic var code: [String]
//    @objc dynamic var filterTitle: String
//    @objc dynamic var gameVersion: String
//    @objc dynamic var isFavorite: String
//
//    convenience init(
//        platform: String,
//        name: String,
//        code: [String],
//        filterTitle: String,
//        gameVersion: String,
//        isFavorite: String
//    ) {
//        self.init()
//        
//        self.platform = platform
//        self.name = name
//        self.code = code
//        self.filterTitle = filterTitle
//        self.gameVersion = gameVersion
//        self.isFavorite = isFavorite
//        
//    }
//   
//    var lightweightRepresentation: Price {
//        return Price(price: price, date: date)
//    }
//    
//}
