//
//  HoofdmenuViewController.swift
//  Tafel Taferelen
//
//  Created by Femke van Son on 13-01-17.
//  Copyright © 2017 Femke van Son. All rights reserved.
//

import UIKit
import Firebase

class HoofdmenuViewController: UIViewController {

    @IBOutlet weak var pfPicture: UIImageView!
    @IBOutlet weak var nextDateBtn: UIButton!
    
    @IBOutlet weak var groupNameBtn: UIButton!
    @IBOutlet weak var noGroupBtn: UIButton!
    @IBOutlet weak var noDateBtn: UIButton!
    
    @IBOutlet weak var oneDinnerDate: UIImageView!
    @IBOutlet weak var twoDinnerDate: UIImageView!
    @IBOutlet weak var threeDinnerDate: UIImageView!
    @IBOutlet weak var fourDinnerDate: UIImageView!
    
    
    var ref: FIRDatabaseReference!
    var fullName = String()
    var tableSetting = [String]()
    
    override func viewDidAppear(_ animated: Bool) {
        viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noGroupBtn.isHidden = true
        
        ref = FIRDatabase.database().reference()
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        

        ref?.child("users").child(userID!).child("urlToImage").observeSingleEvent(of: .value, with: { (snapshot) in
        
            let urlImage = snapshot.value as! String
            
            if let url = NSURL(string: urlImage) {
                
                if let data = NSData(contentsOf: url as URL) {
                    self.pfPicture.image = UIImage(data: data as Data)
                    self.oneDinnerDate.image = UIImage(data: data as Data)
                }
            }
            
        })
        
        self.ref?.child("users").child(userID!).child("full name").observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.fullName = snapshot.value as! String
            
        })
        
        
        self.ref?.child("users").child(userID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let groupID = snapshot.value as? String
            
            if groupID != nil {

                self.ref?.child("groups").child(groupID!).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                    let groupName = snapshot.value as! String
                    self.groupNameBtn.setTitle(groupName, for: .normal)

                })
                
                self.ref?.child("groups").child(groupID!).child("date").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let date = snapshot.value as? String
                    print ("date is", date ?? 0)
                    if date != nil {
                        self.noDateBtn.isHidden = true
                        self.nextDateBtn.setTitle(date, for: .normal)
                    }
                    
                })

            } else {
                self.groupNameBtn.isHidden = true
                self.noGroupBtn.isHidden = false
            }

        })
        
        self.pfPicture.layer.cornerRadius = self.pfPicture.frame.size.width / 2
        self.pfPicture.clipsToBounds = true
        self.oneDinnerDate.layer.cornerRadius = self.oneDinnerDate.frame.size.width / 2
        self.oneDinnerDate.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
