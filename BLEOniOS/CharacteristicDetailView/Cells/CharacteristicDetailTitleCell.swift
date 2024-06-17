//
//  CharacteristicDetailTitleCell.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 6/10/24.
//

import UIKit

class CharacteristicDetailTitleCell: UITableViewCell {
    
    @IBOutlet private weak var idLabel: UILabel!
    private var data: CharacteristicDetailUIModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .white
        idLabel.numberOfLines = 0
        idLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        idLabel.textColor = ColorContext.darkText
    }
    
    func set(data: CharacteristicDetailUIModel) {
        self.data = data
        idLabel.text = data.uuidString
    }
}
