//
//  MissionObject.swift
//  GTAModes
//
//  Created by Максим Педько on 15.08.2023.
//

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
