//
//  Realm+Utilities.swift
//  GTA Modes
//
//  Created by Максим Педько on 27.07.2023.
//

import Foundation
import RealmSwift

public typealias ActionBlock = () -> Void

extension Realm {
    
    /// Force creation of Realm with provided configuration
    /// - parameter configuration: configuration to create Realm with
    public static func forceCreate(with configuration: Realm.Configuration) -> Realm {
        do {
            return try Realm(configuration: configuration)
        } catch {
            fatalError("Realm creation error: \(error)")
        }
    }
    
    /// Soft creation of Realm with provided configuration
    /// - parameter configuration: configuration to create Realm with
    /// - returns: newly created Realm or `nil` in case of error
    public static func softCreate(with configuration: Realm.Configuration) -> Realm? {
        do {
            return try Realm(configuration: configuration)
        } catch {
            return nil
        }
    }
    
    /// Complete deletion of Realm files by provided URL
    ///
    /// WARNING! We always need to be sure that there are 0 allocated realms at this point
    /// (based on Realm documentation)
    /// - parameter fileURL: Realm file URL (can be obtained from `Realm.Configuration`)
    public static func deleteRealm(at fileURL: URL) {
        let realmURLs = [
            fileURL,
            fileURL.appendingPathExtension("lock"),
            fileURL.appendingPathExtension("note"),
            fileURL.appendingPathExtension("management")
        ]
        for URL in realmURLs {
            try? FileManager.default.removeItem(at: URL)
        }
    }
    
    public func forceWrite(_ block: ActionBlock) {
        do {
            if isInWriteTransaction {
                block()
            } else {
                try write {
                    block()
                }
            }
        } catch {
            fatalError("Realm write error: \(error)")
        }
    }
    
    public func writeReturn<T>(_ block: (() throws -> T)) throws -> T {
        var result: T!
        
        try write { () -> Void in
            result = try block()
        }
        
        return result
    }
    
}

