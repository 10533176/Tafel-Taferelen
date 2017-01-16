//
//  HoofdmenuViewController.swift
//  Tafel Taferelen
//
//  Created by Femke van Son on 13-01-17.
//  Copyright © 2017 Femke van Son. All rights reserved.
//

import UIKit
import Firebase

class HoofdmenuViewController: UIViewController {

    @IBOutlet weak var pfPicture: UIImageView!
    @IBOutlet weak var chairBtn: UIButton!
    @IBOutlet weak var chair1Btn: UIButton!
    @IBOutlet weak var chair2Btn: UIButton!
    @IBOutlet weak var chair3Btn: UIButton!
    @IBOutlet weak var chair5Btn: UIButton!
    @IBOutlet weak var chair6Btn: UIButton!
    @IBOutlet weak var chair7Btn: UIButton!
    
    
    var ref: FIRDatabaseReference!
    var fullName = String()
    var tableSetting = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        print (userID ?? 0)
        
        
        ref?.child("users").child(userID!).child("urlToImage").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let urlImage = snapshot.value as! String
            print (urlImage)
            
            
            if let url = NSURL(string: urlImage) {
                
                if let data = NSData(contentsOf: url as URL) {
                    self.pfPicture.image = UIImage(data: data as Data)
                }
            }
            
        })
        
        self.ref?.child("users").child(userID!).child("full name").observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.fullName = snapshot.value as! String
            print (self.fullName)
        })
        
        
        self.pfPicture.layer.cornerRadius = self.pfPicture.frame.size.width / 2
        self.pfPicture.clipsToBounds = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func chair4Pressed(_ sender: Any) {
        
        if chairBtn.titleLabel?.text == nil {
            if tableSetting.contains(fullName) {
                // do nothing
            } else {
                chairBtn.titleLabel?.text = fullName
                chairBtn.setTitle(fullName, for: .normal)
                tableSetting.append(fullName)
            }
        }
        else {
            if chairBtn.titleLabel!.text == fullName {
                chairBtn.titleLabel!.text = nil
                chairBtn.setTitle(nil, for: .normal)
                if let index = tableSetting.index(of: fullName) {
                    tableSetting.remove(at: index)
                }
            }
        }
    }
    
}
