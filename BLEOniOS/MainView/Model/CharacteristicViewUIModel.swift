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
//        case BluetoothContext.rotaryPositionCharacteristic.uuidString:
//        case BluetoothContext.buttonCharacteristic.uuidString:
        case BluetoothContext.colorCharacteristic.uuidString:
            return getColorDisplayValue()
//        case BluetoothContext.modeCharacteristic.uuidString:
        default:
            return value
        }
    }
    
    var imageName: String {
        switch characteristicUuidString {
        case BluetoothContext.rotaryPositionCharacteristic.uuidString:
            return StringContext.ImageName.rotary
            
        case BluetoothContext.colorCharacteristic.uuidString:
            return StringContext.ImageName.color
            
        case BluetoothContext.modeCharacteristic.uuidString:
            return StringContext.ImageName.lightMode
            
        default:
            return StringContext.ImageName.unkown
        }
    }
    
    var serviceName: String {
        switch serviceUuidString {
        case BluetoothContext.inputService.uuidString:
            return StringContext.inputService
        case BluetoothContext.outputService.uuidString:
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
            return "R: \(rgb[0]), G: \(rgb[1]), B: \(rgb[2])"
        }
        
        return value
    }
}

enum CharacteristicRow {
    case noCharactersticFound
    case commonCharacteristic(model: CharacteristicViewUIModel)
}
