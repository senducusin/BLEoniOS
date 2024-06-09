//
//  CharacteristicViewUIModel.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 5/12/24.
//

import Foundation

struct CharacteristicViewUIModel {
    let characteristicName: String
    let characteristicUuidString: String
    let serviceUuidString: String
    let value: String
    let isLast: Bool
}

extension CharacteristicViewUIModel {
    var displayValue: String {
        switch characteristicUuidString {
        case DeviceCharacteristic.color.rawValue:
            return getColorDisplayValue()
            
        default:
            return value
        }
    }
    
    var imageName: String {
        switch characteristicUuidString {
        case DeviceCharacteristic.rotaryPosition.rawValue:
            return StringContext.ImageName.rotary
            
        case DeviceCharacteristic.color.rawValue:
            return StringContext.ImageName.color
            
        case DeviceCharacteristic.mode.rawValue:
            return StringContext.ImageName.lightMode
            
        default:
            return StringContext.ImageName.unkown
        }
    }
    
    var serviceName: String {
        switch serviceUuidString {
        case DeviceService.input.rawValue:
            return StringContext.inputService
        case DeviceService.output.rawValue:
            return StringContext.outputService
        default:
            return serviceUuidString
        }
    }
    
    private func getColorDisplayValue() -> String {
        let rgb = value.split(separator: StringContext.Separator.comma)
            .map { subString in
                String(subString).trimmingCharacters(in: .whitespaces)
            }
    
        if rgb.count == 3 {
            return "(R: \(rgb[0]), G: \(rgb[1]), B: \(rgb[2]))"
        }
        
        return value
    }
}

enum CharacteristicRow {
    case noCharactersticFound
    case commonCharacteristic(model: CharacteristicViewUIModel)
}
