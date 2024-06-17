//
//  CharacteristicDetailRow.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 6/10/24.
//

import Foundation
import CoreBluetooth

enum CharacteristicDetailRow {
    case titleRow(model: CharacteristicDetailUIModel)
    case staticRow(model: CommonDetailRowUIModel)
    case topTitleRow(model: String)
    case writeRow(model: CommonDetailRowUIModel)
    case propertyRow(model: CommonDetailRowUIModel)
}

struct CommonDetailRowUIModel {
    let title: String
    let value: String
    let shouldShowSeparator: Bool
}

struct CharacteristicDetailUIModel {
    private let data: CharacteristicData
    
    init(data: CharacteristicData) {
        self.data = data
    }
    
    var description: String {
        data.description
    }
    
    var uuidString: String {
        data.uuidString
    }
    
    var uuidStringPrefix: String {
        let subString = uuidString.split(separator: StringContext.Separator.dash)
        let prefix = String(subString[0])
        
        return prefix
    }
    
    var isReadOnly: String {
        data.isReadOnly
        ? StringContext.trueStatement
        : StringContext.falseStatement
    }
    
    var isNotifying: String {
        data.willNotify
        ? StringContext.trueStatement
        : StringContext.falseStatement
    }
}
