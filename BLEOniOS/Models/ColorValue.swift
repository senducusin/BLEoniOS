//
//  ColorValue.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 5/12/24.
//

import Foundation

struct ColorValue: Codable {
    let r: Int?
    let g: Int?
    let b: Int?
    
    func getStringValue() -> String? {
        guard let r,
              let g,
              let b
        else { return  nil }
        
        return "\(r), \(g), \(b)"
    }
}
