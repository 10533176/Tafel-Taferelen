//
//  GroupsTableViewCell.swift
//  Tafel Taferelen
//
//  Created by Femke van Son on 17-01-17.
//  Copyright © 2017 Femke van Son. All rights reserved.
//

import UIKit

class GroupsTableViewCell: UITableViewCell {

    @IBOutlet weak var groupMemberName: UILabel!
    @IBOutlet weak var groupMemberProfpic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.groupMemberProfpic.layer.cornerRadius = self.groupMemberProfpic.frame.size.width / 2
        self.groupMemberProfpic.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
