//
//  CharacteristicDetailView.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 5/13/24.
//

import UIKit

protocol CharacteristicDetailViewProtocol {
    func updateSections(with rows: [CharacteristicDetailRow])
    func navigateToWrite(with characteristic: DeviceCharacteristic)
}

class CharacteristicDetailView: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private var rows = [CharacteristicDetailRow]()
    var presenter: CharacteristicDetailPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
        title = presenter?.title
        view.backgroundColor = ColorContext.lightBlue
        setupTable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }
    
    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.register(cells: [
            CharacteristicDetailTopTitleCell.self,
            CharacteristicDetailCell.self,
            CharacteristicDetailTitleCell.self,
            CharacteristicDetailNavCell.self,
            CharacteristicDetailPropertyCell.self
        ])
        tableView.reloadData()
    }
}

extension CharacteristicDetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        
        switch row {
        case let .titleRow(model):
            let cell = tableView.dequeueReusableCell(cellClass: CharacteristicDetailTitleCell.self)
            cell.set(data: model)
            cell.selectionStyle = .none
            return cell
            
        case let .staticRow(model):
            let cell = tableView.dequeueReusableCell(cellClass: CharacteristicDetailCell.self)
            cell.set(value: model)
            cell.selectionStyle = .none
            return cell
            
        case let .writeRow(model):
            let cell = tableView.dequeueReusableCell(cellClass: CharacteristicDetailNavCell.self)
            cell.set(data: model)
            cell.selectionStyle = .none
            return cell
            
        case let .topTitleRow(model):
            let cell = tableView.dequeueReusableCell(cellClass: CharacteristicDetailTopTitleCell.self)
            cell.set(value: model)
            cell.selectionStyle = .none
            return cell
            
        case let .propertyRow(model):
            let cell = tableView.dequeueReusableCell(cellClass: CharacteristicDetailPropertyCell.self)
            cell.set(data: model)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let row = rows[indexPath.row]
        
        switch row {
        case .writeRow:
            guard let id = presenter?.id,
                  let characteristic = DeviceCharacteristic(rawValue: id.uuidString)
            else { return }
            
            switch characteristic {
            case DeviceCharacteristic.color:
                setupColorPicker()
            default:
                navigateToWrite(with: characteristic)
            }
            
        default:
            break
        }
    }
}

extension CharacteristicDetailView {
    private func setupColorPicker() {
        guard let currentColor = presenter?.currentColor
        else { return }
        
        let picker = UIColorPickerViewController()
        picker.selectedColor = currentColor
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }
}

extension CharacteristicDetailView: CharacteristicDetailViewProtocol {
    func navigateToWrite(with characteristic: DeviceCharacteristic) {
        let controller = WriteView()
        let presenter = WritePresenter(controller: controller,
                                       model: characteristic)
        controller.presenter = presenter
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func updateSections(with rows: [CharacteristicDetailRow]) {
        self.rows = rows
        tableView.reloadData()
    }
}

extension CharacteristicDetailView: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        presenter?.didSelectColor(color: viewController.selectedColor)
    }
}
