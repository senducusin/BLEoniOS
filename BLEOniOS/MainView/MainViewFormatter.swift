//
//  MainViewFormatter.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 5/12/24.
//

import Foundation

protocol MainViewFormatterProtocol {
    func convert(_ characteristicData: [CharacteristicData]) -> [CharacteristicRow]
}

class MainViewFormatter: MainViewFormatterProtocol {
    func convert(_ characteristicData: [CharacteristicData]) -> [CharacteristicRow] {
        
        let uiModels: [CharacteristicViewUIModel] = characteristicData.map { characteristic in
            let lastCharacteristic = characteristicData.last
            
            return CharacteristicViewUIModel(characteristicName: characteristic.description,
                                             characteristicUuidString: characteristic.uuidString, 
                                             serviceUuidString: characteristic.cbService.cbService.uuid.uuidString,
                                             value: characteristic.value ?? "",
                                             isLast: characteristic.uuidString == lastCharacteristic?.uuidString)
        }
        
        let rows: [CharacteristicRow] = uiModels.map { uiModel in
            CharacteristicRow.commonCharacteristic(model: uiModel)
        }
        
        return rows
    }
}
