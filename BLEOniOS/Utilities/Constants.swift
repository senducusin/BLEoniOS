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
    
    static let lightGray = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
    static let darkText = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
}

struct StringContext {
    static let enabled = "Enabled"
    static let disabled = "Disabled"
    static let inputService = "Input"
    static let outputService = "Output"
    static let trueStatement = "True"
    static let falseStatement = "False"
    
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

// MARK: - Device Service
enum DeviceService: String {
    case input = "50CB2718-83F9-4EFC-B35B-2544BB24D8B6"
    case output = "CD457CC4-F310-4D7B-ADDD-3291067B12EC"
}

extension DeviceService {
    func getUUID() -> CBUUID {
        CBUUID(string: self.rawValue)
    }
    
    func getName() -> String {
        switch self {
        case .input:
            return StringContext.inputService
            
        case .output:
            return StringContext.outputService
        }
    }
}

// MARK: - Device Characteristic
enum DeviceCharacteristic: String {
    case rotaryPosition = "961C5B3C-4E94-4CEE-84B3-E84A5D036950"
    case color = "D0DF504E-B877-427C-B014-F22DDEFD387A"
    case mode = "F4F7790A-6C50-40C6-9A75-37A0F78A6FB3"
}

extension DeviceCharacteristic {
    func getWriteTemplate(value: Int) -> String {
        """
        {
         "mode": \(value)
        }
        """
    }
    
    func getUUID() -> CBUUID {
        CBUUID(string: self.rawValue)
    }
    
    func getDescription() -> String {
        switch self {
        case .rotaryPosition:
            return "Rotary Position"
        case .color:
            return "Color"
        case .mode:
            return "Lighting Mode"
        }
    }
    
    static func getInputCharacteristics() -> [CBUUID] {
        [
            DeviceCharacteristic.rotaryPosition.getUUID()
        ]
    }
    
    static func getOutputCharacteristics() -> [CBUUID] {
        [
            DeviceCharacteristic.color.getUUID(),
            DeviceCharacteristic.mode.getUUID()
        ]
    }
}

// MARK: - Peripheral
struct PeripheralIdentity {
    let localName: String?
    let name: String?
}
