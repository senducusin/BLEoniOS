//
//  MainViewPresenter.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 5/12/24.
//

import Foundation
import Combine

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
        controller.updateSections(with: rows)
    }
    
    func didSelectRow(with model: CharacteristicViewUIModel) {
//        topvi
        
        
//        self.navigationController?.pushViewController(controller, animated: true)
    }
}
