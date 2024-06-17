//
//  CharacteristicViewCell.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 5/3/24.
//

import UIKit

class CharacteristicViewCell: UITableViewCell {
    @IBOutlet weak private var headingLabel: UILabel!
    @IBOutlet weak private var serviceLabel: UILabel!
    @IBOutlet weak private var valueLabel: UILabel!
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var separatorView: UIView!
    @IBOutlet weak private var chevronImageView: UIImageView!
    
    var model: CharacteristicViewUIModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        
        headingLabel.textColor = ColorContext.primaryText
        
        serviceLabel.textColor = ColorContext.secondaryText
        serviceLabel.adjustsFontSizeToFitWidth = true
        
        valueLabel.textColor = ColorContext.tertiaryText
        
        separatorView.backgroundColor = ColorContext.secondaryText
        chevronImageView.tintColor = ColorContext.secondaryText
        chevronImageView.image = chevronImageView.image?.withRenderingMode(.alwaysTemplate)
        
        selectionStyle = .none
    }
    
    func set(model: CharacteristicViewUIModel) {
        self.model = model
        
        iconImageView.image = UIImage(systemName: model.imageName)
        
        headingLabel.text = model.characteristicName
        
        serviceLabel.text = [StringContext.service,
                             model.serviceName]
            .joined(separator: StringContext.Separator.space)
        
        valueLabel.text = [StringContext.valueColon,
                           model.displayValue]
            .joined(separator: StringContext.Separator.space)
        
        separatorView.isHidden = model.isLast
    }
}
