//
//  MainObject.swift
//  GTAModes
//
//  Created by Максим Педько on 09.08.2023.
//

import Foundation

enum MainType {
    case main, cameSelection
}

struct MainObject {
    
    let title: String
    let type: MainType
    let imagePath: String
    
}
