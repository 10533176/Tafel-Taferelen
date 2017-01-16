//
//  GroupsViewController.swift
//  Tafel Taferelen
//
//  Created by Femke van Son on 16-01-17.
//  Copyright © 2017 Femke van Son. All rights reserved.
//

import UIKit
import Firebase


class GroupsViewController: UIViewController {
    
    var ref: FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        ref = FIRDatabase.database().reference()
        
        self.ref.child("groeps").childByAutoId()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
