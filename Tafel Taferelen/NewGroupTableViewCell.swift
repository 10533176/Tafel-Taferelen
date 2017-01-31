//
//  NewGroupTableViewCell.swift
//  Tafel Taferelen
//
//  Created by Femke van Son on 16-01-17.
//  Copyright © 2017 Femke van Son. All rights reserved.
//

import UIKit

class NewGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var newGroupMemberDisplay: UILabel!
    @IBOutlet weak var newGroupMemberProfPic: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.newGroupMemberProfPic.layer.cornerRadius = self.newGroupMemberProfPic.frame.size.width / 2
        self.newGroupMemberProfPic.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
