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
    
    var groupMembers = [String]()
    var groupPhotos = [String]()
    var groupNames = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
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
                        self.countMembers.text = "Deelnemers: \(counting) van de 10"
                        
                        
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
