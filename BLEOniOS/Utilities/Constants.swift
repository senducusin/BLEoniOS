//
//  Constants.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 5/3/24.
//

import UIKit
import CoreBluetooth

struct ColorContext {
    static let lightBlue = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1)
    
    static let primaryText = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
    static let secondaryText = UIColor(red: 149/255, green: 165/255, blue: 166/255, alpha: 1)
    static let tertiaryText = UIColor(red: 127/255, green: 140/255, blue: 141/255, alpha: 1)
}

struct StringContext {
    static let enabled = "Enabled"
    static let disabled = "Disabled"
    static let inputService = "Input"
    static let outputService = "Output"
    
    struct Separator {
        static let dash: Character = "-"
        static let comma: Character = ","
    }
    
    struct ImageName {
        static let unkown = "questionmark.circle"
        static let rotary = "arrow.triangle.2.circlepath"
        static let color = "paintpalette"
        static let lightMode = "light.max"
    }
}

struct BluetoothContext {
    static let inputService = CBUUID(string: "50CB2718-83F9-4EFC-B35B-2544BB24D8B6")
    static let outputService = CBUUID(string: "CD457CC4-F310-4D7B-ADDD-3291067B12EC")
    
    static let rotaryPositionCharacteristic = CBUUID(string: "961C5B3C-4E94-4CEE-84B3-E84A5D036950")
    static let buttonCharacteristic = CBUUID(string: "28E0C7B8-95E4-4C69-939E-0A7BF68606C5")
    static let colorCharacteristic = CBUUID(string: "D0DF504E-B877-427C-B014-F22DDEFD387A")
    static let modeCharacteristic = CBUUID(string: "F4F7790A-6C50-40C6-9A75-37A0F78A6FB3")
}
