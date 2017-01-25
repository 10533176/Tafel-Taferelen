//
//  NewGroupViewController.swift
//  Tafel Taferelen
//
//  Created by Femke van Son on 16-01-17.
//  Copyright © 2017 Femke van Son. All rights reserved.
//

import UIKit
import Firebase

class NewGroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var groupsName: UITextField!
    @IBOutlet weak var newGroupMember: UITextField!
    @IBOutlet weak var createGroupBtn: UIButton!
    @IBOutlet weak var newGroupMemBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var ref: FIRDatabaseReference!
    var memberEmails = [String]()
    var memberIDs = [String]()
    var memberNames = [String]()
    var memberProfpic = [String]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = true
        ref = FIRDatabase.database().reference()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func newGroupMemberAdded(_ sender: Any) {
        
        if newGroupMember.text != " " {
            if memberIDs.count < 11 {
                
                userAllreadyinGroup()
                
                let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
                
                alert.view.tintColor = UIColor.black
                let frame = CGRect(x: 10, y: 5, width: 50, height: 50)
                
                let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: frame) as UIActivityIndicatorView
                loadingIndicator.hidesWhenStopped = true
                loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                loadingIndicator.startAnimating();
                
                alert.view.addSubview(loadingIndicator)
                present(alert, animated: true, completion: nil)
            } else {
               self.signupErrorAlert(title: "Oops!", message: "Maximum of ten members in group is reached")
            }
        } else {
            self.signupErrorAlert(title: "Oops!", message: "Fill in email adress to add new member to the group!")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberNames.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewGroupTableViewCell
        cell.newGroupMemberDisplay.text = self.memberNames[indexPath.row]
        
        if let url = NSURL(string: self.memberProfpic[indexPath.row]) {
            
            if let data = NSData(contentsOf: url as URL) {
                cell.newGroupMemberProfPic.image = UIImage(data: data as Data)
            }
        }
        return cell
    }
    
    
    @IBAction func createNewGroupPressed(_ sender: Any) {
        
        let groupID = self.ref?.child("groups").childByAutoId().key
        
        if groupsName.text != "" {
            self.ref?.child("groups").child(groupID!).child("name").setValue(groupsName.text)
            saveCurrentUserAsNewMember(groupID: groupID!)
        }
        else {
            self.signupErrorAlert(title: "Oops!", message: "You forgot to fill in a groupsname")
        }
    }
    
    func saveCurrentUserAsNewMember(groupID: String) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        self.ref?.child("users").child(userID!).child("email").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let emailCurrentUser = snapshot.value as! String
            print ("JA EMAIL ARRAY: ", self.memberEmails)
            self.memberEmails.append(emailCurrentUser)
            self.memberIDs.append(userID!)
            
            self.ref?.child("groups").child(groupID).child("members").child("email").setValue(self.memberEmails)
            self.ref?.child("groups").child(groupID).child("members").child("userid").setValue(self.memberIDs)
            let tableSetting = ["", "", "", "", "", "", "", "", "", ""]
            self.ref?.child("groups").child(groupID).child("tableSetting").setValue(tableSetting)
            
            for keys in self.memberIDs {
                print("keys: ", keys)
                self.ref?.child("users").child(keys).child("groupID").setValue(groupID)
            }
            
        })
    }
    
    func userAllreadyinGroup() {
        
        self.ref?.child("emailDB").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let dictionary = snapshot.value as? NSDictionary
            
            if dictionary != nil {
                let tempKeys = dictionary?.allKeys as! [String]
                
                for keys in tempKeys {
                    
                    self.ref?.child("emailDB").child(keys).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let email = snapshot.value as! String
                        
                        if email == self.newGroupMember.text {
                            
                            self.ref?.child("users").child(keys).child("groupID").observeSingleEvent(of: .value, with: {(snapshot) in
                                
                                let checkCurrentGroup = snapshot.value as? String
                                print ("de check is: ", checkCurrentGroup ?? 0)
                                
                                if checkCurrentGroup == nil {
                                    self.displayNewMember()
                                }
                                else {
                                    self.dismiss(animated: false, completion: nil)
                                    self.signupErrorAlert(title: "Oops, user allready in group!", message: "This member is already having dinner with other friends.. Try if someone else will have dinner with you!")
                                    self.newGroupMember.text = ""
                                }
                            })
                        }
                    })
                }
            }
        })
    }
    
    func displayNewMember() {
        
        self.ref?.child("emailDB").observeSingleEvent(of: .value, with: { (snapshot) in
                
            let dictionary = snapshot.value as? NSDictionary
                
            if dictionary != nil {
                let tempKeys = dictionary?.allKeys as! [String]
                    
                for keys in tempKeys {
                        
                    self.ref?.child("emailDB").child(keys).observeSingleEvent(of: .value, with: { (snapshot) in
                            
                        let email = snapshot.value as! String
                            
                        if email == self.newGroupMember.text {
                            
                            self.ref?.child("users").child(keys).child("full name").observeSingleEvent(of: .value, with: {(snapshot) in
                                let name = snapshot.value as! String
                                self.memberNames.append(name)
                            })
                                
                            self.ref?.child("users").child(keys).child("urlToImage").observeSingleEvent(of: .value, with: {(snapshot) in
                                let url = snapshot.value as! String
                                self.memberProfpic.append(url)
                                self.tableView.reloadData()
                            })
                            
                            self.dismiss(animated: false, completion: nil)
                            self.memberEmails.append(self.newGroupMember.text!)
                            self.memberIDs.append(keys)
                            self.newGroupMember.text = ""
                            
                        }
                    })
                }
            } else {
                self.dismiss(animated: false, completion: nil)
            }
        })
    }
    
    func signupErrorAlert(title: String, message: String) {
        
        // Called upon signup error to let the user know signup didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}
