//
//  BLEResponse.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 6/12/24.
//

import Foundation

struct BLEResponse: Codable {
    // Color
    let r: Int?
    let g: Int?
    let b: Int?
    
    // Rotary
    let steps: Int?
    
    // Mode
    let mode: Int?
}

extension BLEResponse {
    var currentMode: LightingMode? {
        LightingMode(rawValue: mode ?? 0)
    }
}

extension BLEResponse {
    func getRGBString() -> String? {
        guard let r,
              let g,
              let b
        else { return  nil }
        
        return "\(r), \(g), \(b)"
    }
    
    func getRGB() -> RGBColor? {
        guard let r,
              let g,
              let b
        else { return  nil }
        
        return RGBColor(r: r, g: g, b: b)
    }
}
        
struct RGBColor {
    let r: Int
    let g: Int
    let b: Int
}

enum LightingMode: Int, CaseIterable {
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
}
