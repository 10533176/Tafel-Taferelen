//
//  ChatTableViewCell.swift
//  Tafel Taferelen
//
//  Created by Femke van Son on 18-01-17.
//  Copyright © 2017 Femke van Son. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var message: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
