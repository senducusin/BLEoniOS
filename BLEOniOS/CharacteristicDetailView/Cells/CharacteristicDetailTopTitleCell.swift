//
//  CharacteristicDetailTitleCell.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 6/10/24.
//

import UIKit

class CharacteristicDetailTopTitleCell: UITableViewCell {
    
    @IBOutlet private weak var idLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .white
        idLabel.numberOfLines = 1
        idLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        idLabel.textColor = ColorContext.lightBlue
    }
    
    func set(value: String) {
        idLabel.text = value
    }
}
