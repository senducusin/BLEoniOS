//
//  CharacteristicDetailPropertyCell.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 6/13/24.
//

import UIKit

class CharacteristicDetailPropertyCell: UITableViewCell {
    
    @IBOutlet weak private var separatorView: UIView!
    @IBOutlet weak private var propertyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .white
        propertyLabel.textColor = ColorContext.tertiaryText
        propertyLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    func set(data: CommonDetailRowUIModel) {
        propertyLabel.text = data.title
        separatorView.backgroundColor = data.shouldShowSeparator
        ? ColorContext.lightGray
        : .clear
    }
}
