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
         willNotify: Bool,
         value: String? = nil) {
        self.description = description
        self.isReadOnly = isReadOnly
        self.willNotify = willNotify
        self.cbCharacteristic = cbCharacteristic
        self.cbService = cbService
        self.value = value
    }
    
    let cbCharacteristic: CBCharacteristic
    let cbService: ServiceData
    let description: String
    let isReadOnly: Bool
    let willNotify: Bool
    
    var id: CBUUID {
        cbCharacteristic.uuid
    }
    
    var value: String?
    
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
