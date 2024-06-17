//
//  CharacteristicModel.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 5/12/24.
//

import Foundation
import CoreBluetooth

class CharacteristicData: Identifiable {
    
    init(cbCharacteristic: CBCharacteristic,
         cbService: ServiceData,
         description: String,
         isReadOnly: Bool,
         willNotify: Bool) {
        self.description = description
        self.isReadOnly = isReadOnly
        self.willNotify = willNotify
        self.cbCharacteristic = cbCharacteristic
        self.cbService = cbService
    }
    
    let cbCharacteristic: CBCharacteristic
    let cbService: ServiceData
    let description: String
    let isReadOnly: Bool
    let willNotify: Bool
    
    var response: BLEResponse?
    
    var value: String? {
        guard let response else { return nil }
        
        switch cbCharacteristic.uuid {
        case DeviceCharacteristic.color.getUUID():
            return response.getRGBString()
            
        case DeviceCharacteristic.mode.getUUID():
            
            return response.currentMode?.getStringValue()
        case DeviceCharacteristic.rotaryPosition.getUUID():
            guard let steps = response.steps else { return nil }
            
            return String(steps)
            
        default:
            return nil
        }
    }
    
    var id: CBUUID {
        cbCharacteristic.uuid
    }
    
    var uuidString: String {
        id.uuidString
    }
    
    var uuidStringPrefix: String {
        let subString = uuidString.split(separator: StringContext.Separator.dash)
        let prefix = String(subString[0])
        
        return prefix
    }
    
    var willAutoUpdate: String {
        willNotify ? StringContext.enabled : StringContext.disabled
    }
}
