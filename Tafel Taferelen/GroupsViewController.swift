//
//  GroupsViewController.swift
//  Tafel Taferelen
//
//  Created by Femke van Son on 16-01-17.
//  Copyright © 2017 Femke van Son. All rights reserved.
//

import UIKit
import Firebase


class GroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countMembers: UILabel!
    @IBOutlet weak var newEmailField: UITextField!
    @IBOutlet weak var addNewMemberBtn: UIButton!
    @IBOutlet weak var LeavingGroupPressed: UIButton!
    
    var groupMembers = [String]()
    var groupPhotos = [String]()
    var groupNames = [String]()
    var newUserId = String()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()

        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        
        self.ref?.child("users").child(userID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let groupID = snapshot.value as? String
            
            if groupID != nil {
                
                self.ref?.child("groups").child(groupID!).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                    let groupNameValue = snapshot.value as? String
                    
                    if groupNameValue != nil {
                        self.groupName.text = groupNameValue
                    }
                    
                 })
                
                self.ref?.child("groups").child(groupID!).child("members").child("userid").observeSingleEvent(of: .value, with: { (snapshot) in

                    if snapshot.value as? NSArray != nil {
                        
                        self.groupMembers = snapshot.value as? NSArray as! [String]
                        
                        let counting = self.groupMembers.count
                        self.countMembers.text = "Members: (\(counting)) of 10"
                        
                        for keys in self.groupMembers {
                            self.ref?.child("users").child(keys).child("urlToImage").observeSingleEvent(of: .value, with: { (snapshot) in
                                
                                let url = snapshot.value as? String
                                if url != nil {
                                    self.groupPhotos.append(url!)
                                }
                            })
                            
                            self.ref?.child("users").child(keys).child("full name").observeSingleEvent(of: .value, with: { (snapshot) in
                                
                                let name = snapshot.value as? String
                                if name != nil {
                                    self.groupNames.append(name!)
                                    self.tableView.reloadData()
                                }
                            })
                        }
                    }
                
                })
            }
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupsTableViewCell
        cell.groupMemberName.text = groupNames[indexPath.row]
        
        if let url = NSURL(string: self.groupPhotos[indexPath.row]) {
            
            if let data = NSData(contentsOf: url as URL) {
                cell.groupMemberProfpic.image = UIImage(data: data as Data)
            }
        }
        
        return cell
    }
    

    @IBAction func leavingGroupPressed(_ sender: Any) {
        // delete current user from tableview
        
        LeavingGroupPressed.isEnabled = false
        let currentUserID = FIRAuth.auth()?.currentUser?.uid
        var emailArray = [String]()
        
        self.ref?.child("users").child(currentUserID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let groupID = snapshot.value as? String
            
            self.ref?.child("users").child(currentUserID!).child("email").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let email = snapshot.value as? String
                
                self.ref?.child("users").child(currentUserID!).child("groupID").removeValue()
                self.ref?.child("groups").child(groupID!).child("members").child("email").observeSingleEvent(of: .value, with: {(snapshot) in
                    emailArray = snapshot.value as? NSArray as! [String]

                    emailArray.remove(at: emailArray.index(of: email!)!)
                    self.ref?.child("groups").child(groupID!).child("members").child("email").setValue(emailArray)
                    })
                    
                self.ref?.child("groups").child(groupID!).child("members").child("userid").observeSingleEvent(of: .value, with: {(snapshot) in
                        var useridArray = snapshot.value as? NSArray as! [String]
                        
                        useridArray.remove(at: useridArray.index(of: currentUserID!)!)
                    self.ref?.child("groups").child(groupID!).child("members").child("userid").setValue(useridArray)

                    })
                
                    self.signupErrorAlert(title: "Bye bye!", message: "You left the group successfully!")
                    self.tableView.reloadData()
            })
        })
        
    }

    
    @IBAction func addNewMemberPressed(_ sender: Any) {
        
        if newEmailField.text != " "  {
            self.userInGroup()
        } else {
            self.signupErrorAlert(title: "Oops!", message: "Vul een emailadres in om iemand toe te voegen aan de groep!")
        }
    }
    
    
    func userInGroup() {
        
        self.ref?.child("emailDB").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let dictionary = snapshot.value as? NSDictionary
            
            if dictionary != nil {
                let tempKeys = dictionary?.allKeys as! [String]
                
                for keys in tempKeys {
                    print ("keys: ", keys)
                    self.ref?.child("emailDB").child(keys).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let email = snapshot.value as! String
                        
                        if email == self.newEmailField.text {
                            
                            self.ref?.child("users").child(keys).child("groupID").observeSingleEvent(of: .value, with: {(snapshot) in
                                
                                let checkCurrentGroup = snapshot.value as? String
                                print ("de check is: ", checkCurrentGroup ?? 0)
                                
                                if checkCurrentGroup == nil {
                                    self.newMemberAddedToGroup(userID: keys)
                                }
                                else {
                                    self.signupErrorAlert(title: "Oops!", message: "Deze gebruiker zit al in een andere groep")
                                }
                            })
                        }
                    })
                }
            }
        })
    }
    
    func newMemberAddedToGroup(userID: String) {

        if userID != "" {
            
            let currentUserID = FIRAuth.auth()?.currentUser?.uid
            self.groupMembers.append(userID)
            let counting = self.groupMembers.count
            self.countMembers.text = "Deelnemers: \(counting) van de 10"
            var emailArray = [String]()
            
            self.ref?.child("users").child(currentUserID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let groupID = snapshot.value as! String
                
                self.ref?.child("groups").child(groupID).child("members").child("email").observeSingleEvent(of: .value, with: {(snapshot) in
                    
                    emailArray = snapshot.value as? NSArray as! [String]
                    emailArray.append(self.newEmailField.text!)
                    self.ref?.child("groups").child(groupID).child("members").child("email").setValue(emailArray)
                    
                })
                
                self.ref?.child("users").child(userID).child("groupID").setValue(groupID)
                
                self.ref?.child("groups").child(groupID).child("members").child("userid").setValue(self.groupMembers)
            })
            
            self.ref?.child("users").child(userID).child("full name").observeSingleEvent(of: .value, with: {(snapshot) in
                let name = snapshot.value as! String
                self.groupNames.append(name)
            })
            
            self.ref?.child("users").child(userID).child("urlToImage").observeSingleEvent(of: .value, with: {(snapshot) in
                let url = snapshot.value as! String
                self.groupPhotos.append(url)
                self.tableView.reloadData()
            })

        }
    }
    
    func signupErrorAlert(title: String, message: String) {
        
        // Called upon signup error to let the user know signup didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}
