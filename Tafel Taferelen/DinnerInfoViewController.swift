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
        
        if #available(iOS 10.0, *) {
            let refreshControl = UIRefreshControl()
            let title = NSLocalizedString("PullToRefresh", comment: "refresh chat")
            refreshControl.attributedTitle = NSAttributedString(string: title)
            refreshControl.addTarget(self,
                                     action: #selector(refreshOptions(sender:)),
                                     for: .valueChanged)
            tableView.refreshControl = refreshControl
        }

    }

    
    @objc private func refreshOptions(sender: UIRefreshControl) {
        readChat()
        sender.endRefreshing()
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
        
        let numberOfSections = self.tableView.numberOfSections
        let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
        
        let indexPath = IndexPath(row: numberOfRows-1 , section: numberOfSections-1)
        self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
        
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
                
                self.ref?.child("groups").child(groupID).child("chat").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let dictionary = snapshot.value as? NSDictionary
                    
                    if dictionary != nil {
                        
                        var dateStemps = dictionary?.allKeys as! [String]
                        dateStemps = dateStemps.sorted()
                        print ("dateStamps: ", dateStemps)
                        
                        for key in dateStemps {
                            
                            print ("DATE ORDER: ", key)
                            self.ref?.child("groups").child(groupID).child("chat").child(key).child("message").observeSingleEvent(of: .value, with: { (snapshot) in
                                let singleChat = snapshot.value as? String
                                if singleChat != nil {
                                    self.chat.insert(singleChat!, at: self.chat.count)
                                    print("Chat Array!!!", self.chat)
                                }
                              })
                            
                            self.ref?.child("groups").child(groupID).child("chat").child(key).child("userid").observeSingleEvent(of: .value, with: { (snapshot) in
                                let singleUser = snapshot.value as? String
                                if singleUser != nil {
                                    self.ref?.child("users").child(singleUser!).child("full name").observeSingleEvent(of: .value, with: { (snapshot) in
                                        
                                        let username = snapshot.value as? String
                                        if username  != nil {
                                            self.sender.insert(username!, at: self.sender.count)
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
    
    func newChatMes() {
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let mesID = formatter.string(from: Date())
        
        self.ref?.child("users").child(userID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let valueCheck = snapshot.value as? String
            if valueCheck != nil {
                let groupID = valueCheck!
                print ("GROUPID: ", groupID)
                
                self.ref?.child("groups").child(groupID).child("chat").child(mesID).child("userid").setValue(userID)
                self.ref?.child("groups").child(groupID).child("chat").child(mesID).child("message").setValue(self.newMessageText.text)
                self.newMessageText.text = ""
                self.readChat()
            }
        })
        
    }

}
