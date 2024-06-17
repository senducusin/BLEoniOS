//
//  WritePresenter.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 6/16/24.
//

import Foundation

protocol WritePresenterProtocol {
    var description: String { get }
    
    func viewDidLoad()
    func viewWillAppear()
    func writeValue(_ value: Int)
}

class WritePresenter : WritePresenterProtocol {
    
    private var controller: WriteViewProtocol
    private var model: DeviceCharacteristic
    
    init(controller: WriteViewProtocol,
         model: DeviceCharacteristic) {
        self.controller = controller
        self.model = model
    }
    
    var description: String {
        model.getDescription()
    }
    
    func viewDidLoad() {
        let template = model.getWriteTemplate(value: 0)
        controller.updatePreview(with: template)
    }
    
    func viewWillAppear() {
        
    }
    
    func writeValue(_ value: Int) {
        let request = model.getWriteTemplate(value: value)
        BluetoothService.shared.updateValueOf(model, with: request)
    }
}
