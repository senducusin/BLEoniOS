//
//  MainViewPresenter.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 5/12/24.
//

import Foundation

protocol MainViewPresenterProtocol {
    func viewDidLoad()
    func viewWillAppear()
    func didSelectRow(with model: CharacteristicViewUIModel)
}

protocol BluetoothServiceDelegate {
    func updateCharacteristicData(with characteristicData: [CharacteristicData])
}

class MainViewPresenter: MainViewPresenterProtocol {
    
    private var controller: MainViewControllerProtocol
    private var bleService: BluetoothServiceProtocol
    private var formatter: MainViewFormatterProtocol
    
    init(controller: MainViewControllerProtocol,
         bleService: BluetoothServiceProtocol,
         formatter: MainViewFormatterProtocol){
        self.controller = controller
        self.bleService = bleService
        self.formatter = formatter
        
        self.bleService.delegate = self
    }
    
    func viewDidLoad() { }
    
    func viewWillAppear() { }
}

extension MainViewPresenter: BluetoothServiceDelegate {
    func updateCharacteristicData(with characteristicData: [CharacteristicData]) {
        let rows = formatter.convert(characteristicData)
        
        let model = PeripheralUIModel(peripheralIdentity: bleService.peripheral,
                                      servicesCount: bleService.services.count,
                                      characteristicRows: rows)
        
        controller.updateSections(with: model)
    }
    
    func didSelectRow(with model: CharacteristicViewUIModel) { 
        guard let selectedCharacteristic = bleService.characteristicData
            .first(where: { $0.id.uuidString == model.characteristicUuidString})
        else { return }
        
        controller.navigateToDetails(with: selectedCharacteristic)
    }
}
