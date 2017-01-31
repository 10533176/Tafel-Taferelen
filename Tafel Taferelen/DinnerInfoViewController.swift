//
//  DinnerInfoViewController.swift
//  Tafel Taferelen
//
//  Created by Femke van Son on 17-01-17.
//  Copyright © 2017 Femke van Son. All rights reserved.
//

import UIKit
import Firebase
import EventKit

class DinnerInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var dateNextDinnerField: UITextField!
    @IBOutlet weak var locationNextDinnerField: UITextField!
    @IBOutlet weak var chefNextDinnerField: UITextField!
    @IBOutlet weak var newMessageText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveDateBtn: UIButton!
    @IBOutlet weak var coverUpImage: UIImageView!
    
    var chat = [String]()
    var sender = [String]()
    var chatID = [String]()
    var dinnerDate = NSDate()
    let userID = FIRAuth.auth()?.currentUser?.uid
    
    var keyboardSizeRect: CGRect?
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.isHidden = true
        coverUpImage.isHidden = true

        ref = FIRDatabase.database().reference()
        loadExistingGroupInfo()
        readChat()
        refreshTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: functions for reloading tableview when dragged down
    func refreshTableView() {
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

    // MARK: functions for properly hide and show keyboard
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardSizeRect = keyboardSize
        }
    }
    
    @IBAction func didBeginChatting(_ sender: Any) {
        
        if self.view.frame.origin.y == 0{
            if let keyboardSize = keyboardSizeRect {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @IBAction func didEndChatting(_ sender: Any) {
        if let keyboardSize = keyboardSizeRect {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    // MARK: Saving new info when location or chef textfield changed
    @IBAction func locationChanged(_ sender: Any) {
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
    
    // MARK: when datePicker is touched, selecting/ displaying and saving new date
    @IBAction func EdditingDateDidBegin(_ sender: Any) {
        dateNextDinnerField.isHidden = true
        coverUpImage.isHidden = false
        datePicker.isHidden = false
    }
    
    @IBAction func datpickerChanged(_ sender: Any) {
        dinnerDate = datePicker.date as NSDate
        
        let date = dinnerDate
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = .short
        let dateDinnerStiring = formatter.string(from: date as Date)
        dateNextDinnerField.text = dateDinnerStiring
        
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        datePicker.isHidden = true
        coverUpImage.isHidden = true
        dateNextDinnerField.isHidden = false
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

    @IBAction func saveDateCalendar(_ sender: Any) {
        signupErrorAlert(title: "Save the Date", message: "Date is saved to your calendar!")
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        var components = gregorian.components([.year, .month, .day, .hour], from: dinnerDate as Date)
        components.hour = components.hour! + 4
        
        let endDate = gregorian.date(from: components)!
        addEventToCalendar(title: "Dinner with \(groupNameLabel.text!)", description: "©Ready, Set, Dinner", startDate: dinnerDate, endDate: endDate as NSDate)
        
    }
    
    // MARK: Loading information from group
    func loadExistingGroupInfo() {
        
        self.ref?.child("users").child(userID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let groupID = snapshot.value as? String
            if groupID != nil {
                self.getGroupName(groupID: groupID!)
                self.getGroupChef(groupID: groupID!)
                self.getGroupLocation(GroupID: groupID!)
                self.getGroupNextDate(groupID: groupID!)
            }
        })
    }
    
    func getGroupName(groupID: String)  {
        self.ref?.child("groups").child(groupID).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let groupName = snapshot.value as? String
            self.groupNameLabel.text = groupName
        })
    }
    
    func getGroupNextDate(groupID: String) {
        self.ref?.child("groups").child(groupID).child("date").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let date = snapshot.value as? String
            if date != nil {
                self.dateNextDinnerField.text = date
            }
        })
    }
    
    func getGroupChef(groupID: String) {
        self.ref?.child("groups").child(groupID).child("chef").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let chef = snapshot.value as? String
            if chef != nil {
                self.chefNextDinnerField.text = chef
            }
        })
    }
    
    func getGroupLocation(GroupID: String) {
        self.ref?.child("groups").child(GroupID).child("location").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let location = snapshot.value as? String
            if location != nil {
                self.locationNextDinnerField.text = location
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
        self.ref?.child("users").child(userID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let groupID = snapshot.value as? String

            if groupID != nil {
                self.readingchatInOrder(groupID: groupID!)
            } else {
                self.signupErrorAlert(title: "Oops", message: "Join or create a dinner group to pick a date for the dinner!")
            }
        })
    }
    
    func readingchatInOrder(groupID: String) {
        
        self.ref?.child("groups").child(groupID).child("chat").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            let dictionary = snapshot.value as? NSDictionary
            
            if dictionary != nil {
                self.readingMessages(groupID: groupID, messagesDic: dictionary!)
                self.readingSenderIDs(groupID: groupID, messagesDic: dictionary!)
            }
        })
    }
    
    func readingMessages(groupID: String, messagesDic: NSDictionary) {
        
        var dateStemps = messagesDic.allKeys as! [String]
        dateStemps = dateStemps.sorted()
        
        for key in dateStemps {
            
            self.ref?.child("groups").child(groupID).child("chat").child(key).child("message").observeSingleEvent(of: .value, with: { (snapshot) in
                let singleChat = snapshot.value as? String
                if singleChat != nil {
                    self.chat.insert(singleChat!, at: self.chat.count)
                }
            })
        }
    }
    
    func readingSenderIDs(groupID: String, messagesDic: NSDictionary) {
        var dateStemps = messagesDic.allKeys as! [String]
        dateStemps = dateStemps.sorted()
        
        for key in dateStemps {
            
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
    
    // MARK: Sending new chat message
    func newChatMes() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let mesID = formatter.string(from: Date())
        
        self.ref?.child("users").child(userID!).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let valueCheck = snapshot.value as? String
            if valueCheck != nil {
                let groupID = valueCheck!

                self.ref?.child("groups").child(groupID).child("chat").child(mesID).child("userid").setValue(self.userID)
                self.ref?.child("groups").child(groupID).child("chat").child(mesID).child("message").setValue(self.newMessageText.text)
                self.newMessageText.text = ""
                self.readChat()
            }
        })
        
    }
    
    func addEventToCalendar(title: String, description: String?, startDate: NSDate, endDate: NSDate, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate as Date
                event.endDate = endDate as Date
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    
    // MARK: displaying chat in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
}
