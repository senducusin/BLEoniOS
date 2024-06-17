//
//  CharacteristicDetailRow.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 6/10/24.
//

import UIKit

class CharacteristicDetailCell: UITableViewCell {
    
    @IBOutlet weak private var keyLabel: UILabel!
    @IBOutlet weak private var valueLabel: UILabel!
    @IBOutlet weak private var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .white
        valueLabel.numberOfLines = 0
        keyLabel.numberOfLines = 0
        
        keyLabel.textColor = ColorContext.darkText
        valueLabel.textColor = ColorContext.darkText
        
        keyLabel.font = UIFont.systemFont(ofSize: 18)
    }
    
    func set(value: CommonDetailRowUIModel) {
        keyLabel.text = value.title
        valueLabel.text = value.value.trimmingCharacters(in: .whitespacesAndNewlines)
        
        separatorView.backgroundColor = .clear
    }
}
