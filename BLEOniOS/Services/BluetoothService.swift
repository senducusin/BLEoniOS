//
//  BluetoothService.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 5/12/24.
//

import Foundation
import CoreBluetooth

protocol BluetoothServiceProtocol {
    var services: [CBUUID] { get }
    var characteristicData: [CharacteristicData] { get }
    var delegate: BluetoothServiceDelegate? { get set }
}

class BluetoothService: NSObject, BluetoothServiceProtocol, ObservableObject {
    static let shared = BluetoothService()
    
    private var centralManager: CBCentralManager?
    private var connectedPeripheral: CBPeripheral?
    var services = [CBUUID]()
    var characteristicData = [CharacteristicData]()
    var delegate: BluetoothServiceDelegate?
    
    var peripheralStatus: ConnectionStatus = .disconnected
    var rotaryPositionValue = 0
    var lightingMode = LightingMode.none
    var lightColor: String?
    
    var shouldConnect: Bool = true {
        didSet {
            handleConnection()
        }
    }
    
    override init() {
        super.init()
        services = [BluetoothContext.inputService,
                    BluetoothContext.outputService]
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
}

// MARK: - CBCentralManagerDelegate Methods
extension BluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            shouldScanForPeripherals()
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        connectedPeripheral = peripheral
        centralManager?.connect(peripheral) // does not have a strong reference, keep it on prototypePeripheral
        peripheralStatus = .connecting
    }
    
    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral) {
        peripheralStatus = .connected
        peripheral.delegate = self
        
        // interrogate peripheral
        peripheral.discoverServices(services)
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDisconnectPeripheral peripheral: CBPeripheral,
                        error: Error?) {
        peripheralStatus = .disconnected
        characteristicData.removeAll()
    }
    
    func centralManager(_ central: CBCentralManager,
                        didFailToConnect peripheral: CBPeripheral,
                        error: Error?) {
        peripheralStatus = .error
        print(error?.localizedDescription ?? "No error")
    }
}

extension BluetoothService: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            if service.uuid == BluetoothContext.inputService {
                peripheral.discoverCharacteristics([BluetoothContext.rotaryPositionCharacteristic,
                                                    BluetoothContext.modeCharacteristic],
                                                   for: service)
            } else if service.uuid == BluetoothContext.outputService {
                peripheral.discoverCharacteristics([BluetoothContext.colorCharacteristic,
                                                    BluetoothContext.modeCharacteristic],
                                                   for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service:
                    CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        let serviceName = getServiceName(using: service.uuid)
        let serviceData = ServiceData(description: serviceName, cbService: service)
        
        for characteristic in characteristics {
            if characteristic.uuid == BluetoothContext.rotaryPositionCharacteristic {
                characteristicData.append(CharacteristicData(cbCharacteristic: characteristic,
                                                             cbService: serviceData,
                                                             description: "Rotary Position",
                                                             isReadOnly: false,
                                                             willNotify: true))
                
            } else if characteristic.uuid == BluetoothContext.colorCharacteristic {
                characteristicData.append(CharacteristicData(cbCharacteristic: characteristic,
                                                             cbService: serviceData,
                                                             description: "Color",
                                                             isReadOnly: true,
                                                             willNotify: false))
                
            } else if characteristic.uuid == BluetoothContext.modeCharacteristic {
                characteristicData.append(CharacteristicData(cbCharacteristic: characteristic,
                                                             cbService: serviceData,
                                                             description: "Lighting Mode",
                                                             isReadOnly: false,
                                                             willNotify: true))
            }
            
            peripheral.readValue(for: characteristic)
            
            guard characteristic.uuid != BluetoothContext.colorCharacteristic else { continue }
            
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value
        else { return }
        
        if characteristic.uuid == BluetoothContext.rotaryPositionCharacteristic {
            decode(data) { [weak self] (bleData: BLERotaryPositionValue?) in
                guard let rotaryPosition = bleData?.value,
                      let self else { return }
                
                print(rotaryPosition)
                self.rotaryPositionValue = rotaryPosition
                
                self.characteristicData = self.characteristicData.map({
                    if $0.id == characteristic.uuid {
                        $0.value = String(rotaryPosition)
                    }
                    
                    return $0
                })
            }
            
        } else if characteristic.uuid == BluetoothContext.colorCharacteristic {
            decode(data) { [weak self] (bleData: ColorValue?) in
                guard let color = bleData?.getStringValue(),
                      let self else { return }
                
                self.lightColor = color
                
                self.characteristicData = self.characteristicData.map({
                    if $0.id == characteristic.uuid {
                        $0.value = color
                    }
                    
                    return $0
                })
            }
            
        } else if characteristic.uuid == BluetoothContext.modeCharacteristic {
            decode(data) { [weak self] (bleData: BLELightingValue?) in
                guard let activeMode = bleData?.currentMode,
                      let self else { return }
                
                self.lightingMode = activeMode
                
                self.characteristicData = self.characteristicData.map({
                    if $0.id == characteristic.uuid {
                        $0.value = activeMode.getStringValue()
                    }
                    
                    return $0
                })
            }
        }
        
        delegate?.updateCharacteristicData(with: characteristicData)
    }
}

// MARK: - Private Helpers
extension BluetoothService {
    private func handleConnection() {
        if shouldConnect {
            shouldScanForPeripherals()
        } else {
            guard let connectedPeripheral else { return }
            
            centralManager?.cancelPeripheralConnection(connectedPeripheral)
        }
    }
    
    private func shouldScanForPeripherals() {
        guard shouldConnect else { return }
        
        scanForPeripherals()
    }
    
    private func scanForPeripherals() {
        peripheralStatus = .scanning
        centralManager?.scanForPeripherals(withServices: services)
    }
    
    private func decode<T: Decodable>(_ data: Data, completion: @escaping((T?) -> Void)) {
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            completion(result)
        } catch {
            print(error.localizedDescription)
            completion(nil)
        }
    }
    
    private func updateValueOf(_ characteristic: CharacteristicData, with value: Any?) {
        guard let connectedPeripheral else { return }
        
        let encoder = JSONEncoder()
        
        if characteristic.uuidString == BluetoothContext.modeCharacteristic.uuidString {
            guard let value = value as? LightingMode else { return }
            
            let model = BLELightingValue(value: value.rawValue)
            
            if let payload = try? encoder.encode(model) {
                connectedPeripheral.writeValue(payload, for: characteristic.cbCharacteristic,
                                               type: .withResponse)
            }
        }
    }
    
    private func getServiceName(using uuid: CBUUID) -> String {
        switch uuid.uuidString {
        case BluetoothContext.inputService.uuidString:
            return StringContext.inputService
            
        case BluetoothContext.outputService.uuidString:
            return StringContext.outputService
            
        default:
            return uuid.uuidString
        }
    }
}
