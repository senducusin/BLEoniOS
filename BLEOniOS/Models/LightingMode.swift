//
//  LightingMode.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 5/12/24.
//

import Foundation

enum LightingMode: Int {
    case chase
    case trail
    case fade
    case manual
    case none
    
    func getStringValue() -> String {
        switch self {
        case .chase:
            return "Chase"
        case .trail:
            return "Trail"
        case .fade:
            return "Fade"
        case .manual:
            return "Manual"
        case .none:
            return "None"
        }
    }
    
//    static func getAllCaseStrings() -> [String] {
//        ["Chase", "Trail", "Fade", "Manual", "None"]
//    }
//    
//    static func getAllCases() -> [LightingMode] {
//        [.chase, .trail, .fade, .manual, .none]
//    }
}

struct BLELightingValue: Codable {
    let value: Int?
    
    var currentMode: LightingMode? {
        LightingMode(rawValue: value ?? 0)
    }
}
