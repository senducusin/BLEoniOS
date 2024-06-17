//
//  CharacteristicDetailNavCell.swift
//  BLEOniOS
//
//  Created by Jansen Ducusin on 6/13/24.
//

import UIKit

class CharacteristicDetailNavCell: UITableViewCell {
    
    @IBOutlet weak var rowTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        rowTitleLabel.textAlignment = .center
        rowTitleLabel.textColor = .link
        rowTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        backgroundColor = .white
    }
    
    func set(data: CommonDetailRowUIModel) {
        rowTitleLabel.text = data.title
    }
}
