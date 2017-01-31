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
    
    @IBOutlet weak var imageSeat1: UIImageView!
    @IBOutlet weak var imageSeat2: UIImageView!
    @IBOutlet weak var imageSeat3: UIImageView!
    @IBOutlet weak var imageSeat4: UIImageView!
    @IBOutlet weak var imageSeat5: UIImageView!
    @IBOutlet weak var imageSeat6: UIImageView!
    @IBOutlet weak var imageSeat7: UIImageView!
    @IBOutlet weak var imageSeat8: UIImageView!
    @IBOutlet weak var imageSeat9: UIImageView!
    @IBOutlet weak var imageSeat10: UIImageView!

    var ref: FIRDatabaseReference!
    var tableSetting = [String]()
    var pfURL = String()
    var nameOfPicture = UIImageView()
    let userID = FIRAuth.auth()?.currentUser?.uid
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func loadProfilePicture() {
        
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
    
    func getGroupInfo() {
        
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

    func getGroupName(groupID: String) {
        
        self.ref?.child("groups").child(groupID).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            let groupName = snapshot.value as! String
            self.groupNameBtn.setTitle(groupName, for: .normal)
            self.groupNameBtn.titleLabel!.font =  UIFont(name: "HelveticaNeue-Regular", size: 22)
            self.groupNameBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.groupNameBtn.contentHorizontalAlignment = .left
        })
    }
    
    func getGroupDate(groupID: String) {
        
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
    
    func getTableSetting(groupID: String) {
        
        self.ref?.child("groups").child(groupID).child("tableSetting").observeSingleEvent(of: .value, with: { (snapshot) in
            let table = snapshot.value as? [String]
            if table != nil {
                self.tableSetting = table!
                self.filInTable()
            }
        })
    }
    
    // MARK: enabeling user to pick a seat at the table or remove current seat 
    
    @IBAction func seat1Pressed(_ sender: Any) {
        saveSeat(seat: 0)
    }
    @IBAction func seat2Pressed(_ sender: Any) {
        saveSeat(seat: 1)
    }
    @IBAction func seat3Pressed(_ sender: Any) {
        saveSeat(seat: 2)
    }
    @IBAction func seat4Pressed(_ sender: Any) {
        saveSeat(seat: 3)
    }
    @IBAction func seat5Pressed(_ sender: Any) {
        saveSeat(seat: 4)
    }
    @IBAction func seat6Pressed(_ sender: Any) {
        saveSeat(seat: 5)
    }
    @IBAction func seat7Pressed(_ sender: Any) {
        saveSeat(seat: 6)
    }
    @IBAction func seat8Pressed(_ sender: Any) {
        saveSeat(seat: 7)
    }
    @IBAction func seat9Pressed(_ sender: Any) {
        saveSeat(seat: 8)
    }
    @IBAction func seat10Pressed(_ sender: Any) {
        saveSeat(seat: 9)
    }
    
    
    func saveSeat(seat: Int) {
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        if tableSetting.isEmpty == false {
            if self.tableSetting[seat] == "" {
                
                if self.tableSetting.contains(self.pfURL) {
                    self.signupErrorAlert(title: "Oops!", message: "You allready have a seat at the table!")
                    return
                }
                
                self.tableSetting[seat] = self.pfURL
                
                self.ref?.child("users").child(userID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let groupID = snapshot.value as? String
                    
                    if groupID != nil {
                        print ("table setting changed: ", self.tableSetting)
                        self.ref?.child("groups").child(groupID!).child("tableSetting").setValue(self.tableSetting)
                        self.displayOwnPicture(seat: seat)
                    }
                })
                
            } else if self.tableSetting[seat] == self.pfURL {
                self.tableSetting[seat] = ""
                
                self.ref?.child("users").child(userID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let groupID = snapshot.value as? String
                    
                    if groupID != nil {
                        self.ref?.child("groups").child(groupID!).child("tableSetting").setValue(self.tableSetting)
                        self.emptyOwnPicture(seat: seat)
                        
                    }
                })
            } else if self.tableSetting[seat] != "" && self.tableSetting[seat] != self.pfURL && self.tableSetting.contains(self.pfURL) == false{
                //self.signupErrorAlert(title: "Oops!", message: "Pick an empty seat.")
            }
        }

    }
    
    func displayOwnPicture(seat: Int) {
    
        if let url = NSURL(string: pfURL) {
            
            if let data = NSData(contentsOf: url as URL) {
                
                if seat == 0 {
                    self.imageSeat1.image = UIImage(data: data as Data)
                    self.imageSeat1.layer.cornerRadius = self.imageSeat1.frame.size.width / 2
                    self.imageSeat1.clipsToBounds = true
                }
                if seat == 1 {
                    self.imageSeat2.image = UIImage(data: data as Data)
                    self.imageSeat2.layer.cornerRadius = self.imageSeat1.frame.size.width / 2
                    self.imageSeat2.clipsToBounds = true
                }
                if seat == 2 {
                    self.imageSeat3.image = UIImage(data: data as Data)
                    self.imageSeat3.layer.cornerRadius = self.imageSeat1.frame.size.width / 2
                    self.imageSeat3.clipsToBounds = true
                }
                if seat == 3 {
                    self.imageSeat4.image = UIImage(data: data as Data)
                    self.imageSeat4.layer.cornerRadius = self.imageSeat1.frame.size.width / 2
                    self.imageSeat4.clipsToBounds = true
                }
                if seat == 4 {
                    self.imageSeat5.image = UIImage(data: data as Data)
                    self.imageSeat5.layer.cornerRadius = self.imageSeat1.frame.size.width / 2
                    self.imageSeat5.clipsToBounds = true
                }
                if seat == 5 {
                    self.imageSeat6.image = UIImage(data: data as Data)
                    self.imageSeat6.layer.cornerRadius = self.imageSeat1.frame.size.width / 2
                    self.imageSeat6.clipsToBounds = true
                }
                if seat == 6 {
                    self.imageSeat7.image = UIImage(data: data as Data)
                    self.imageSeat7.layer.cornerRadius = self.imageSeat1.frame.size.width / 2
                    self.imageSeat7.clipsToBounds = true
                }
                if seat == 7 {
                    self.imageSeat8.image = UIImage(data: data as Data)
                    self.imageSeat8.layer.cornerRadius = self.imageSeat1.frame.size.width / 2
                    self.imageSeat8.clipsToBounds = true
                }
                if seat == 8 {
                    self.imageSeat9.image = UIImage(data: data as Data)
                    self.imageSeat9.layer.cornerRadius = self.imageSeat1.frame.size.width / 2
                    self.imageSeat9.clipsToBounds = true
                }
                if seat == 9 {
                    self.imageSeat10.image = UIImage(data: data as Data)
                    self.imageSeat10.layer.cornerRadius = self.imageSeat1.frame.size.width / 2
                    self.imageSeat10.clipsToBounds = true
                }
            }
        }
    }
    
    func emptyOwnPicture(seat: Int) {
        
        if seat == 0 {
            self.imageSeat1.image = nil
        }
        if seat == 1 {
            self.imageSeat2.image = nil
        }
        if seat == 2 {
            self.imageSeat3.image = nil
        }
        if seat == 3 {
            self.imageSeat4.image = nil
        }
        if seat == 4 {
            self.imageSeat5.image = nil
        }
        if seat == 5 {
            self.imageSeat6.image = nil
        }
        if seat == 6 {
            self.imageSeat7.image = nil
        }
        if seat == 7 {
            self.imageSeat8.image = nil
        }
        if seat == 8 {
            self.imageSeat9.image = nil
        }
        if seat == 9 {
            self.imageSeat10.image = nil
        }

    }
    
    func filInTable() {
        
        for key in tableSetting {
            if key != "" {
                if let url = NSURL(string: key) {
                    
                    if let data = NSData(contentsOf: url as URL) {
                        
                        if key == tableSetting[0] {
                            self.imageSeat1.image = UIImage(data: data as Data)
                            self.imageSeat1.layer.cornerRadius = self.imageSeat1.frame.size.width / 2
                            self.imageSeat1.clipsToBounds = true
                        }
                        if key == tableSetting[1] {
                            self.imageSeat2.image = UIImage(data: data as Data)
                            self.imageSeat2.layer.cornerRadius = self.imageSeat1.frame.size.width / 2
                            self.imageSeat2.clipsToBounds = true
                        }
                        if key == tableSetting[2] {
                            self.imageSeat3.image = UIImage(data: data as Data)
                            self.imageSeat3.layer.cornerRadius = self.imageSeat1.frame.size.width / 2
                            self.imageSeat3.clipsToBounds = true
                        }
                        if key == tableSetting[3] {
                            self.imageSeat4.image = UIImage(data: data as Data)
                            self.imageSeat4.layer.cornerRadius = self.imageSeat1.frame.size.width / 2
                            self.imageSeat4.clipsToBounds = true
                        }
                        if key == tableSetting[4] {
                            self.imageSeat5.image = UIImage(data: data as Data)
                            self.imageSeat5.layer.cornerRadius = self.imageSeat1.frame.size.width / 2
                            self.imageSeat5.clipsToBounds = true
                        }
                        if key == tableSetting[5] {
                            self.imageSeat6.image = UIImage(data: data as Data)
                            self.imageSeat6.layer.cornerRadius = self.imageSeat1.frame.size.width / 2
                            self.imageSeat6.clipsToBounds = true
                        }
                        if key == tableSetting[6] {
                            self.imageSeat7.image = UIImage(data: data as Data)
                            self.imageSeat7.layer.cornerRadius = self.imageSeat1.frame.size.width / 2
                            self.imageSeat7.clipsToBounds = true
                        }
                        if key == tableSetting[7] {
                            self.imageSeat8.image = UIImage(data: data as Data)
                            self.imageSeat8.layer.cornerRadius = self.imageSeat1.frame.size.width / 2
                            self.imageSeat8.clipsToBounds = true
                        }
                        if key == tableSetting[8] {
                            self.imageSeat9.image = UIImage(data: data as Data)
                            self.imageSeat9.layer.cornerRadius = self.imageSeat1.frame.size.width / 2
                            self.imageSeat9.clipsToBounds = true
                        }
                        if key == tableSetting[9] {
                            self.imageSeat10.image = UIImage(data: data as Data)
                            self.imageSeat10.layer.cornerRadius = self.imageSeat1.frame.size.width / 2
                            self.imageSeat10.clipsToBounds = true
                        }
                    }
                }
            }
        }
    }
    
}
