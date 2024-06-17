//
//  CharacteristicDetailTitleCell.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 6/10/24.
//

import UIKit

class CharacteristicDetailTopTitleCell: UITableViewCell {
    
    @IBOutlet private weak var topTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = ColorContext.lightGray
        topTitle.numberOfLines = 1
        topTitle.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        topTitle.textColor = ColorContext.darkText
    }
    
    func set(value: String) {
        topTitle.text = value
    }
}
