//
//  HoofdmenuViewController.swift
//  Tafel Taferelen
//
//  Created by Femke van Son on 13-01-17.
//  Copyright © 2017 Femke van Son. All rights reserved.
//

import UIKit
import Firebase
import EventKit

class HoofdmenuViewController: UIViewController {

    @IBOutlet weak var pfPicture: UIImageView!
    @IBOutlet weak var nextDateBtn: UIButton!
    @IBOutlet weak var groupNameBtn: UIButton!
    @IBOutlet weak var noGroupBtn: UIButton!
    @IBOutlet weak var noDateBtn: UIButton!

    
    @IBOutlet var plates: [UIImageView]!
    
    var ref: FIRDatabaseReference!
    var tableSetting = [String]()
    var pfURL = String()
    var nameOfPicture = UIImageView()
    let userID = FIRAuth.auth()?.currentUser?.uid
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableSetting = [""]
        noGroupBtn.isHidden = true

        ref = FIRDatabase.database().reference()
        
        loadProfilePicture()
        getGroupInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewDidLoad()
    }
    
    // MARK: Loading the user and group info to display 
    private func loadProfilePicture() {
        
        ref?.child("users").child(userID!).child("urlToImage").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let urlImage = snapshot.value as? String
            
            if urlImage != nil {
                self.pfURL = urlImage!
                if let url = NSURL(string: urlImage!) {
                    
                    if let data = NSData(contentsOf: url as URL) {
                        self.pfPicture.image = UIImage(data: data as Data)
                    }
                }
            }
        })
        
        self.pfPicture.layer.cornerRadius = self.pfPicture.frame.size.width / 2
        self.pfPicture.clipsToBounds = true
    }
    
    private func getGroupInfo() {
        
        self.ref?.child("users").child(userID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let groupID = snapshot.value as? String
            
            if groupID != nil {
                self.getGroupName(groupID: groupID!)
                self.getGroupDate(groupID: groupID!)
                self.getTableSetting(groupID: groupID!)
                
            } else {
                self.groupNameBtn.isHidden = true
                self.noGroupBtn.isHidden = false
            }
        })
    }

    private func getGroupName(groupID: String) {
        
        self.ref?.child("groups").child(groupID).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            let groupName = snapshot.value as! String
            self.groupNameBtn.setTitle(groupName, for: .normal)
            self.groupNameBtn.titleLabel!.font =  UIFont(name: "HelveticaNeue-Regular", size: 22)
            self.groupNameBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.groupNameBtn.contentHorizontalAlignment = .left
        })
    }
    
    private func getGroupDate(groupID: String) {
        
        self.ref?.child("groups").child(groupID).child("date").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let date = snapshot.value as? String
            if date != nil {
                self.noDateBtn.isHidden = true
                self.nextDateBtn.setTitle(date, for: .normal)
                self.nextDateBtn.titleLabel!.font =  UIFont(name: "HelveticaNeue-Regular", size: 16)
                self.nextDateBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
            }
        })
    }
    
    private func getTableSetting(groupID: String) {
        
        self.ref?.child("groups").child(groupID).child("tableSetting").observeSingleEvent(of: .value, with: { (snapshot) in
            let table = snapshot.value as? [String]
            if table != nil {
                self.tableSetting = table!
                self.filInTable()
            }
        })
    }
    
    // MARK: enabeling user to pick a seat at the table or remove current seat 
    @IBAction func clickedPlate(_ sender: UIButton) {
        saveSeat(seat: sender.tag)
    }
    
    private func saveSeat(seat: Int) {
        
        if tableSetting.isEmpty == false {
            
            if self.tableSetting[seat] == "" {
                self.seatClickedIsOwn(seat: seat)
                
            } else if self.tableSetting[seat] == self.pfURL {
                self.seatClickedIsOwn(seat: seat)
            }
        }

    }
    
    private func seatClickedEmpty(seat: Int) {
        
        if self.tableSetting.contains(self.pfURL) {
            self.signupErrorAlert(title: "Oops!", message: "You allready have a seat at the table!")
        } else {
            self.tableSetting[seat] = self.pfURL
            
            self.ref?.child("users").child(userID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let groupID = snapshot.value as? String
                
                if groupID != nil {
                    self.ref?.child("groups").child(groupID!).child("tableSetting").setValue(self.tableSetting)
                    self.filInTable()
                }
            })
        }
    }
    
    private func seatClickedIsOwn(seat: Int) {
        self.tableSetting[seat] = ""
        
        self.ref?.child("users").child(userID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let groupID = snapshot.value as? String
            
            if groupID != nil {
                self.ref?.child("groups").child(groupID!).child("tableSetting").setValue(self.tableSetting)
                self.plates[seat].image = nil
            }
        })
    }
    
    private func filInTable() {
        
        var indexTable = 0
        for key in tableSetting {
            
            if key != "" {
                if let url = NSURL(string: key) {
                    
                    if let data = NSData(contentsOf: url as URL) {
                        makeImageRound(indexTable: indexTable, key: key, data: data as Data)
                    }
                }
            }
            indexTable += 1
        }
    }
    
    private func makeImageRound(indexTable: Int, key: String, data: Data) {
        if key == tableSetting[indexTable] {
            
            plates[indexTable].image = UIImage(data: data as Data)
            plates[indexTable].layer.cornerRadius = self.plates[indexTable].frame.size.width / 2
            plates[indexTable].clipsToBounds = true
        }
    }
    
}
