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
    var peripheral: PeripheralIdentity? { get }
}

class BluetoothService: NSObject, BluetoothServiceProtocol, ObservableObject {
    static let shared = BluetoothService()
    
    private var centralManager: CBCentralManager?
    private var connectedPeripheral: CBPeripheral?
    var peripheral: PeripheralIdentity?
    var services = [CBUUID]()
    var characteristicData = [CharacteristicData]()
    var delegate: BluetoothServiceDelegate?
    
    var peripheralStatus: ConnectionStatus = .disconnected
    
    var shouldConnect: Bool = true {
        didSet {
            handleConnection()
        }
    }
    
    override init() {
        super.init()
        services = [DeviceService.input.getUUID(),
                    DeviceService.output.getUUID()]
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
        getPeripheralName(peripheral: peripheral, advertisementData: advertisementData)
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
            if service.uuid == DeviceService.input.getUUID() {
                peripheral.discoverCharacteristics(DeviceCharacteristic.getInputCharacteristics(),
                                                   for: service)
                
            } else if service.uuid == DeviceService.output.getUUID() {
                peripheral.discoverCharacteristics(DeviceCharacteristic.getOutputCharacteristics(),
                                                   for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverCharacteristicsFor service:
                    CBService, error: Error?) {
        guard let characteristics = service.characteristics,
              let discoveredService = DeviceService(rawValue: service.uuid.uuidString)
        else { return }
        
        let serviceName = discoveredService.getName()
        let serviceData = ServiceData(description: serviceName, cbService: service)
        
        for characteristic in characteristics {
            guard let deviceCharacteristic = DeviceCharacteristic(rawValue: characteristic.uuid.uuidString)
            else { continue }
            
            var shouldNotify = false
            var shouldReadOnly = false
            
            if characteristic.properties.contains(.notify) {
                shouldNotify.toggle()
            }
            
            if !characteristic.properties.contains(.write) {
                shouldReadOnly.toggle()
            }
            
            let discoveredCharacteristic = CharacteristicData(cbCharacteristic: characteristic,
                                                              cbService: serviceData,
                                                              description: deviceCharacteristic.getDescription(),
                                                              isReadOnly: shouldReadOnly,
                                                              willNotify: shouldNotify)
            
            characteristicData.append(discoveredCharacteristic)
            
            peripheral.readValue(for: characteristic)
            peripheral.setNotifyValue(shouldNotify, for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value
        else { return }
        
        decode(data) { [unowned self] (response: BLEResponse?) in
            guard let response else { return }
            
            self.characteristicData = self.characteristicData.map {
                if $0.id == characteristic.uuid {
                    $0.response = response
                }
                
                return $0
            }
        }
        
        delegate?.updateCharacteristicData(with: characteristicData)
        NotificationCenter.default.post(name: .updateCharacteristics,
                                        object: nil,
                                        userInfo: ["data": characteristicData])
    }
    
    func updateValueOf(_ deviceCharacteristic: DeviceCharacteristic, with value: String) {
        guard let characteristic = characteristicData.first(where: { $0.cbCharacteristic.uuid == deviceCharacteristic.getUUID() })?.cbCharacteristic
        else { return }
        
        let request = Data(value.utf8)
        connectedPeripheral?.writeValue(request, for: characteristic, type: .withResponse)
    }
    
    func getCurrentColor() -> RGBColor? {
        guard let colorCharacteristic = characteristicData.first(where: { $0.id == DeviceCharacteristic.color.getUUID() })
        else { return nil }
        
        return colorCharacteristic.response?.getRGB()
    }
}

// MARK: - Private Helpers
extension BluetoothService {
    private func getPeripheralName(peripheral: CBPeripheral,
                                   advertisementData: [String : Any]) {
        let peripheralLocalName_advertisement = ((advertisementData as NSDictionary).value(forKey: "kCBAdvDataLocalName")) as? String
        self.peripheral = PeripheralIdentity(localName: peripheralLocalName_advertisement, name: peripheral.name)
    }
    
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
    
}
