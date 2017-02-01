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
    var groupEmails = [String]()
    let userID = FIRAuth.auth()?.currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        
        AppDelegate.instance().showActivityIndicator()
        getGroupInfo()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doneLoading() {
        AppDelegate.instance().dismissActivityIndicator()
    }
    
    // MARK: Loading group information 
    func getGroupInfo() {
        self.ref?.child("users").child(userID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let groupID = snapshot.value as? String
            
            if groupID != nil {
                self.getGroupName(groupID: groupID!)
            } else {
                self.doneLoading()
                self.signupErrorAlert(title: "Oops", message: "we could'n find your group, please try again later!")
            }
        })
    }

    func getGroupName(groupID: String) {
        
        self.ref?.child("groups").child(groupID).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            let groupNameValue = snapshot.value as? String
            
            if groupNameValue != nil {
                self.groupName.text = groupNameValue
                self.getGroupMembers(groupID: groupID)
            }
        })
    }
    
    func getGroupMembers(groupID: String) {
        self.ref?.child("groups").child(groupID).child("members").child("userid").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.value as? NSArray != nil {
                self.groupMembers = snapshot.value as? NSArray as! [String]
                self.readingImageName()
            }
        })
    }
    
    func readingImageName() {
        self.countMembers.text = "Members: (\(self.groupMembers.count)) of 10"
        
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
                    self.doneLoading()
                    self.tableView.reloadData()
                }
            })
        }

    }
    
    // MARK: deleting user from group
    @IBAction func leavingGroupPressed(_ sender: Any) {
        LeavingGroupPressed.isEnabled = false
        self.getImageURL()
        
        self.ref?.child("users").child(userID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let groupID = snapshot.value as? String
            if groupID != nil {
                self.deleteUserID(groupID: groupID!)
                self.deleteEmail(groupID: groupID!)
            }
        })
    }
    
    func deleteEmail(groupID: String) {
        
        var emailArray = [String]()
        self.ref?.child("users").child(userID!).child("email").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let email = snapshot.value as? String
            
            self.ref?.child("groups").child(groupID).child("members").child("email").observeSingleEvent(of: .value, with: {(snapshot) in
                emailArray = snapshot.value as? NSArray as! [String]
                if email != nil {
                    emailArray.remove(at: emailArray.index(of: email!)!)
                    self.ref?.child("groups").child(groupID).child("members").child("email").setValue(emailArray)
                }
            })
        })
    }
    
    func deleteUserID(groupID: String) {
        self.ref?.child("groups").child(groupID).child("members").child("userid").observeSingleEvent(of: .value, with: {(snapshot) in
            var useridArray = snapshot.value as? NSArray as! [String]
            useridArray.remove(at: useridArray.index(of: self.userID!)!)
            self.ref?.child("groups").child(groupID).child("members").child("userid").setValue(useridArray)
            self.ref?.child("users").child(self.userID!).child("groupID").removeValue()
            
        })
    }
    
    // MARK: deleting picture from table when user left the group 
    
    func getImageURL() {
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        self.ref?.child("users").child(userID!).child("urlToImage").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let urlImage = snapshot.value as? String
            
            if urlImage != nil {
                self.changeProfileTable(url: urlImage!)
            }
        })
        
    }
    
    func changeProfileTable(url: String) {
        let currentUserID = FIRAuth.auth()?.currentUser?.uid
        
        self.ref?.child("users").child(currentUserID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let groupID = snapshot.value as? String
            
            if groupID != nil {
                
                self.ref?.child("groups").child(groupID!).child("tableSetting").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    var table = snapshot.value as? [String]
                    var index = 0
                    if table != nil {
                        for key in table! {
                            if key == url {
                                table?[index] = ""
                                self.ref?.child("groups").child(groupID!).child("tableSetting").setValue(table)
                            }
                            index = index + 1
                        }
                    }
                })
            }
        })
    }
    
    // MARK: New user added to the group
    @IBAction func addNewMemberPressed(_ sender: Any) {
        
        if newEmailField.text != " "  {
            self.findNewUser()
            AppDelegate.instance().showActivityIndicator()
        } else {
            self.signupErrorAlert(title: "Oops!", message: "Fill in an emailadress to add a new member.")
        }
    }
    
    
    func findNewUser() {
        self.groupEmails = [""]
        self.ref?.child("emailDB").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let dictionary = snapshot.value as? NSDictionary
            
            if dictionary != nil {
                let tempKeys = dictionary?.allKeys as! [String]
                
                for keys in tempKeys {

                    self.ref?.child("emailDB").child(keys).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let email = snapshot.value as! String
                        
                        self.groupEmails.append(email)
                        
                        if self.groupEmails.count == tempKeys.count {
                            self.NewUserNotFound()
                            print ("heeft nieuwe functie aangeroepen omdat die niet kan vinden :")
                        }
                        
                        if email == self.newEmailField.text {
                            self.isNewUserInGroup(newUserID: keys)
                            print ("gaat nieuwe functie aanroepen dat die is gevonden met userid:", keys)
                        }
                    })
                }
            }
        })
    }
    
    func NewUserNotFound() {
        if self.groupEmails.contains(self.newEmailField.text!) == false {
            self.doneLoading()
            self.signupErrorAlert(title: "Oops!", message: "We do not have any users with this e-mail address")
        }
    }
    
    func isNewUserInGroup(newUserID: String){
        self.ref?.child("users").child(newUserID).child("groupID").observeSingleEvent(of: .value, with: {(snapshot) in
            
            let checkCurrentGroup = snapshot.value as? String
            
            if checkCurrentGroup == nil {
                print ("nieuwe user zit niet in groep")
                self.newMemberAddedToGroup(newUserID: newUserID)
            }
            else {
                self.doneLoading()
                self.signupErrorAlert(title: "Oops!", message: "This member is allready in another group. Try to find other friends!")
            }
        })
    }
    
    func newMemberAddedToGroup(newUserID: String) {
        if newUserID != "" {
            if groupMembers.count < 11 {
                self.groupMembers.append(newUserID)
                let counting = self.groupMembers.count
                self.countMembers.text = "Deelnemers: \(counting) van de 10"
                self.saveUserInDB(newUserID: newUserID)
            } else {
                self.doneLoading()
                self.signupErrorAlert(title: "Oops!", message: "Maximum of ten members in group is reached!")
            }
        } else {
            self.doneLoading()
        }
    }
    
    func saveUserInDB(newUserID: String) {
        var emailArray = [String]()
        self.ref?.child("users").child(userID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in

            let groupID = snapshot.value as? String
            
            if groupID != nil {
                print (groupID)

                self.ref?.child("groups").child(groupID!).child("members").child("email").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    emailArray = snapshot.value as? NSArray as! [String]
                    emailArray.append(self.newEmailField.text!)
                    self.ref?.child("groups").child(groupID!).child("members").child("email").setValue(emailArray)
                    
                })
            }
            
            self.ref?.child("users").child(newUserID).child("groupID").setValue(groupID)
            self.ref?.child("groups").child(groupID!).child("members").child("userid").setValue(self.groupMembers)
            self.displayNewUser(newUserID: newUserID)
        })
    }
    
    func displayNewUser(newUserID: String) {
        
        self.ref?.child("users").child(newUserID).child("full name").observeSingleEvent(of: .value, with: {(snapshot) in
            let name = snapshot.value as! String
            self.groupNames.append(name)
        })
        
        self.ref?.child("users").child(newUserID).child("urlToImage").observeSingleEvent(of: .value, with: {(snapshot) in
            let url = snapshot.value as! String
            self.groupPhotos.append(url)
            self.doneLoading()
            self.newEmailField.text = ""
            self.tableView.reloadData()
        })
    }
    
    // MARK: hide ans show keyboard on drag
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
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
    
    // MARK: functions for displaying the users in tableview
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
}
