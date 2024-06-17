//
//  PeripheralUIModel.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 6/17/24.
//

import Foundation

struct PeripheralUIModel {
    let peripheralIdentity: PeripheralIdentity?
    let servicesCount: Int
    let characteristicRows: [CharacteristicRow]
}
