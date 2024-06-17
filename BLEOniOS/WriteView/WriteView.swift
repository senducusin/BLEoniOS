//
//  WriteView.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 6/16/24.
//

import UIKit

protocol WriteViewProtocol {
    func updatePreview(with value: String)
}

class WriteView: UIViewController {

    @IBOutlet weak private var upperBackgroundView: UIView!
    @IBOutlet weak private var modePicker: UIPickerView!
    @IBOutlet weak private var writeCTA: UIButton!
    
    var presenter: WritePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        
        view.backgroundColor = ColorContext.lightBlue
        upperBackgroundView.backgroundColor = ColorContext.lightGray
        
        title = StringContext.setValue
        
        modePicker.delegate = self
        modePicker.dataSource = self
        modePicker.setValue(ColorContext.darkText, forKey: StringContext.Key.textColor)
        
        writeCTA.setTitleColor(ColorContext.lightBlue, for: .normal)
        writeCTA.setTitleColor(ColorContext.lightGray, for: .disabled)
    }
    
    @IBAction private func buttonDidTap(_ sender: UIButton) {
        navigationController?.popViewController() { [unowned self] in
            presenter?.writeValue(modePicker.selectedRow(inComponent: 0))
            writeCTA.isEnabled = false
        }
    }
}

extension WriteView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        LightingMode.allCases.count - 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        LightingMode.allCases[row].getStringValue()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if !writeCTA.isEnabled {
            writeCTA.isEnabled.toggle()
        }
    }
}

extension WriteView: WriteViewProtocol {
    func updatePreview(with value: String) {
    }
}
