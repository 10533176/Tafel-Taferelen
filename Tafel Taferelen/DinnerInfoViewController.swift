//
//  DinnerInfoViewController.swift
//  Tafel Taferelen
//
//  Created by Femke van Son on 17-01-17.
//  Copyright © 2017 Femke van Son. All rights reserved.
//

import UIKit
import Firebase

class DinnerInfoViewController: UIViewController {

    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var dateNextDinnerField: UITextField!
    @IBOutlet weak var locationNextDinnerField: UITextField!
    @IBOutlet weak var chefNextDinnerField: UITextField!
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        ref = FIRDatabase.database().reference()
        
        self.ref?.child("users").child(userID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let groupID = snapshot.value as? String
            
            if groupID != nil {
                
                self.ref?.child("groups").child(groupID!).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let groupName = snapshot.value as? String
                    self.groupNameLabel.text = groupName
                })
                
                
                self.ref?.child("groups").child(groupID!).child("date").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let date = snapshot.value as? String
                    if date != nil {
                        self.dateNextDinnerField.text = date
                    }

                })
                
                self.ref?.child("groups").child(groupID!).child("location").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let location = snapshot.value as? String
                    if location != nil {
                        self.locationNextDinnerField.text = location
                    }
                })
                
                self.ref?.child("groups").child(groupID!).child("chefs").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let chef = snapshot.value as? String
                    if chef != nil {
                        self.chefNextDinnerField.text = chef
                    }
                })
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func locationChanged(_ sender: Any) {
        print ("CHECK")
        print(locationNextDinnerField.text ?? 0)
    }

}
