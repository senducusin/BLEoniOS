//
//  CharacteristicDetailPresenter.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 6/10/24.
//

import Foundation
import UIKit
import CoreBluetooth

protocol CharacteristicDetailPresenterProtocol {
    var title: String { get }
    var id: CBUUID { get }
    var currentColor: UIColor? { get }
    
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func didSelectRow()
    func didSelectColor(color: UIColor)
}

class CharacteristicDetailPresenter: CharacteristicDetailPresenterProtocol {
    
    private var controller: CharacteristicDetailViewProtocol
    private var model: CharacteristicData
    
    var title: String {
        model.description
    }
    
    var id: CBUUID {
        model.id
    }
    
    var currentColor: UIColor? {
        guard let rgb = model.response?.getRGB()
        else { return nil }
        
        return UIColor(red: CGFloat(Float(rgb.r/255)),
                       green: CGFloat(Float(rgb.g/255)),
                       blue: CGFloat(Float(rgb.b/255)),
                       alpha: 1)
    }
    
    init(controller: CharacteristicDetailViewProtocol,
         model: CharacteristicData) {
        self.controller = controller
        self.model = model
    }
    
    func viewDidLoad() { 
        let rows = CharacteristicFormatter.getDetailSection(with: model)
        controller.updateSections(with: rows)
    }
    
    func viewWillAppear() { 
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateCharacteristic),
                                               name: .updateCharacteristics,
                                               object: nil)
    }
    
    func viewWillDisappear() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func didSelectRow() { }
    
    func didSelectColor(color: UIColor) {
        let rgb = color.rgba
        let request = BLEResponse(r: rgb.r, g: rgb.g, b: rgb.b, steps: nil, mode: nil)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(request),
           let json = String(data: encoded, encoding: .utf8) {
            BluetoothService.shared.updateValueOf(DeviceCharacteristic.color,
                                                  with: json)
        }
    }
}

extension CharacteristicDetailPresenter {
    
    @objc func updateCharacteristic(notification: NSNotification) {
        guard let dictionary = notification.userInfo as? NSDictionary,
              let data = dictionary["data"] as? [CharacteristicData],
              let currentModel = data.filter({ $0.id == self.model.id }).first
        else { return }
        
        self.model = currentModel
        let rows = CharacteristicFormatter.getDetailSection(with: model)
        controller.updateSections(with: rows)
    }
}
