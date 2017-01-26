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
    
    var keyboardSizeRect: CGRect?
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.isHidden = true
        coverUpImage.isHidden = true

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

    @IBAction func saveDateCalendar(_ sender: Any) {
        signupErrorAlert(title: "Save the Date", message: "Date is saved to your calendar!")
        print ("NS DATE TO CHANGE = ", dinnerDate)
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        var components = gregorian.components([.year, .month, .day, .hour], from: dinnerDate as Date)
        components.hour = components.hour! + 4
        
        let endDate = gregorian.date(from: components)!
        addEventToCalendar(title: "Dinner with \(groupNameLabel.text!)", description: "Remember or die!", startDate: dinnerDate, endDate: endDate as NSDate)
        
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
    

    @IBAction func dateChanged(_ sender: Any) {
        datePicker.isHidden = true
        coverUpImage.isHidden = true
        dateNextDinnerField.isHidden = false
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
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = DateFormatter.Style.short
                        dateFormatter.timeStyle = .short
                        let datetoNSDate = dateFormatter.date(from: date!)
                        self.dinnerDate = datetoNSDate as NSDate!
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
    
    func addEventToCalendar(title: String, description: String?, startDate: NSDate, endDate: NSDate, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        print ("komt hier")
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                print("gaat hier doorheen")
                print("STARTDATE SAVING: ", startDate)
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate as Date
                event.endDate = endDate as Date
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                    print("gaat hier doorheen!!!!")
                } catch let e as NSError {
                    print ("error date opslaan: ", e)
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
                print ("zit hier")
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
