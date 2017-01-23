//
//  DinnerInfoViewController.swift
//  Tafel Taferelen
//
//  Created by Femke van Son on 17-01-17.
//  Copyright © 2017 Femke van Son. All rights reserved.
//

import UIKit
import Firebase

class DinnerInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var dateNextDinnerField: UITextField!
    @IBOutlet weak var locationNextDinnerField: UITextField!
    @IBOutlet weak var chefNextDinnerField: UITextField!
    @IBOutlet weak var newMessageText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var chat = [String]()
    var sender = [String]()
    var chatID = [String]()
    
    var keyboardSizeRect: CGRect?
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()
        loadExistingGroupInfo()
        readChat()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.keyboardSizeRect = keyboardSize
        }
        
    }
    
    @IBAction func locationChanged(_ sender: Any) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        let newLocation = locationNextDinnerField.text
        
        if newLocation != "" {
            self.ref?.child("users").child(userID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let groupID = snapshot.value as? String
                
                if groupID != nil {
                    self.ref?.child("groups").child(groupID!).child("location").setValue(newLocation)
                }
            })
        }
    }
    
    @IBAction func chefsChanged(_ sender: Any) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        let newDate = chefNextDinnerField.text
        
        if newDate != "" {
            self.ref?.child("users").child(userID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let groupID = snapshot.value as? String
                
                if groupID != nil {
                    self.ref?.child("groups").child(groupID!).child("chef").setValue(newDate)
                }
            })
        }
    }
    
    @IBAction func didBeginChatting(_ sender: Any) {

        if self.view.frame.origin.y == 0{
            if let keyboardSize = keyboardSizeRect {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @IBAction func didEndChatting(_ sender: Any) {
        if let keyboardSize = keyboardSizeRect {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    

    @IBAction func dateChanged(_ sender: Any) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        let newChef = dateNextDinnerField.text
        
        if newChef != "" {
            self.ref?.child("users").child(userID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let groupID = snapshot.value as? String
                
                if groupID != nil {
                    self.ref?.child("groups").child(groupID!).child("date").setValue(newChef)
                }
            })
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("chat array: ", chat)
        print ("chat count = ", chat.count)
        return chat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatTableViewCell
        if self.sender.isEmpty == false  && self.chat.isEmpty == false && self.sender.count == self.chat.count {
            cell.message.text = self.chat[indexPath.row]
            cell.chatName.text = self.sender[indexPath.row]

        }
        return cell
    }
    
    
    
    func loadExistingGroupInfo() {
        let userID = FIRAuth.auth()?.currentUser?.uid
        
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
                
                self.ref?.child("groups").child(groupID!).child("chef").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let chef = snapshot.value as? String
                    if chef != nil {
                        self.chefNextDinnerField.text = chef
                    }
                })
            }
        })

    }
    
    
    @IBAction func messageSendPressed(_ sender: Any) {
        
        if newMessageText.text! != "" {
            newChatMes()
            self.tableView.reloadData()
        }

    }
    
    func readChat() {
        self.chat = []
        self.sender = []

        let userID = FIRAuth.auth()?.currentUser?.uid
        var groupID = String()
        
        self.ref?.child("users").child(userID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let valueCheck = snapshot.value as? String
            if valueCheck != nil {
                groupID = valueCheck!
                print ("GROUPID: ", groupID)
                
                self.ref?.child("groups").child(groupID).child("chat").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let dict = snapshot.value as? NSDictionary
                    
                    if dict != nil {
                        self.chatID = (dict?.allKeys as? [String])!
                        print("chatID", self.chatID)
                        print("test", self.chatID[0])
                    
                    self.ref?.child("groups").child(groupID).child("chat").child(self.chatID[0]).observeSingleEvent(of: .value, with: { (snapshot) in
                            
                        let dict = snapshot.value as? NSDictionary
                            
                        if dict != nil {
                            let chatIDs = dict?.allKeys as! [String]

                            for key in chatIDs {
                                print ("userid:", key)
                                
                                self.ref?.child("groups").child(groupID).child("chat").child(self.chatID[0]).child(key).child("message").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                                    let mes = snapshot.value as? String
                                    if mes != nil {
                                        print ("mes: ", mes!)
                                        self.chat.append(mes!)
                                    }
                                })
                                self.ref?.child("groups").child(groupID).child("chat").child(self.chatID[0]).child(key).child("userid").queryOrdered(byChild: "userid").observeSingleEvent(of: .value, with: { (snapshot) in
                                    let userkey = snapshot.value as? String
                                    if userkey != nil {
                                        self.ref?.child("users").child(userkey!).child("full name").observeSingleEvent(of: .value, with: { (snapshot) in
                                            
                                            let username = snapshot.value as? String
                                            if username  != nil {
                                                self.sender.append(username!)
                                                print ("username count = ", self.sender.count)
                                                self.tableView.reloadData()
                                            }
                                        })
                                    }
                                })

                            }
                        }
                    })
                    }
                })
            }
        })
    }
    
    func newChatMes() {
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        self.ref?.child("users").child(userID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let valueCheck = snapshot.value as? String
            if valueCheck != nil {
                let groupID = valueCheck!
                print ("GROUPID: ", groupID)
                
                self.ref?.child("groups").child(groupID).child("chat").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let dict = snapshot.value as? NSDictionary
                    
                    if dict != nil {
                        let temp = dict?.allKeys as! [String]
                        let chatID = temp[0]
                        let mesID = (self.ref?.child("groups").child(groupID).child("chat").child(chatID).childByAutoId().key)!
                    self.ref?.child("groups").child(groupID).child("chat").child(chatID).child(mesID).child("userid").setValue(userID)
                    self.ref?.child("groups").child(groupID).child("chat").child(chatID).child(mesID).child("message").setValue(self.newMessageText.text)
                        self.readChat()
  
                    } else {
                        let chatID = (self.ref?.child("groups").child(groupID).child("chat").childByAutoId().key)!
                        let mesID = (self.ref?.child("groups").child(groupID).child("chat").child(chatID).childByAutoId().key)!
                    self.ref?.child("groups").child(groupID).child("chat").child(chatID).child(mesID).child("userid").setValue(userID)
                    self.ref?.child("groups").child(groupID).child("chat").child(chatID).child(mesID).child("message").setValue(self.newMessageText.text)
                        self.readChat()
                        
                    }
                })
            }
        })
    }

}
