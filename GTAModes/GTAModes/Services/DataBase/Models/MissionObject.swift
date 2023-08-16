//
//  MissionObject.swift
//  GTAModes
//
//  Created by Максим Педько on 15.08.2023.
//

import Foundation
import RealmSwift

struct MissionParser: Codable {
    let randomEvents: MissionCategory
    let strangersAndFreaks: MissionCategory
    let mandatoryMissionStrangersAndFreaks: MissionCategory
    let strangersAndFreaksHobbiesAndPastimes: MissionCategory
    let sideMission: MissionCategory
    let mandatoryMissionHeist: MissionCategory
    let branchingChoiceHeist: MissionCategory
    let branchingChoice: MissionCategory
    let missableMission: MissionCategory
    let mandatoryMission: MissionCategory
    let misscellaneous: MissionCategory
    let randomMission: MissionCategory
    let strangers: MissionCategory
    let hobby: MissionCategory
    let task: MissionCategory

    private enum CodingKeys: String, CodingKey {
        case randomEvents = "RandomEvents"
        case strangersAndFreaks = "StrangersAndFreaks"
        case mandatoryMissionStrangersAndFreaks = "MandatoryMissionStrangersAndFreaks"
        case strangersAndFreaksHobbiesAndPastimes = "StrangersAndFreaksHobbiesAndPastimes"
        case sideMission = "SideMission"
        case mandatoryMissionHeist = "MandatoryMissionHeist"
        case branchingChoiceHeist = "Branchingchoiceheist"
        case branchingChoice = "Branchingchoice"
        case missableMission = "Missablemission"
        case mandatoryMission = "Mandatorymission"
        case misscellaneous = "Misscellaneous"
        case randomMission = "Randommission"
        case strangers = "Strangers"
        case hobby = "Hobby"
        case task = "Task"
    }
}

struct MissionCategory: Codable {
    let name: String
    let missions: [String]

    private enum CodingKeys: String, CodingKey {
        case name
        case missions
    }
}

public struct MissionItem {
    
    var categoryName: String = ""
    var missionName: String = ""
    var isCheck: Bool = false
    
    init(categoryName: String, missionName: String, isCheck: Bool) {
        self.categoryName = categoryName
        self.missionName = missionName
        self.isCheck = isCheck
    }
    
}

public final class MissionObject: Object {
    
    @objc dynamic private(set) var id: String = UUID().uuidString.lowercased()
    @objc dynamic var category: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var isCheck: Bool = false
    
    override public static func primaryKey() -> String? {
        return #keyPath(MissionObject.id)
    }

    convenience init(
        category: String,
        name: String,
        isCheck: Bool
    ) {
        self.init()
        self.category = category
        self.name = name
        self.isCheck = isCheck
    }
    
    var lightweightRepresentation: MissionItem {
        return MissionItem(categoryName: category, missionName: name, isCheck: isCheck)
    }
    
}
