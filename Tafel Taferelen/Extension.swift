//
//  AlertFunctions.swift
//  Tafel Taferelen
//
//  Created by Femke van Son on 31-01-17.
//  Copyright © 2017 Femke van Son. All rights reserved.
//

import Foundation
import Firebase

extension UIViewController {
    
    // MARK: functions to give alert massages for the user interface
    
    func signupErrorAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func noGroupErrorAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: { action in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVC")
            self.present(vc, animated: true, completion: nil)
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: getting the groupID of a user. WERKT NOG NIET, RETURNT VOORDAT DIE DE WAARDE HEEFT
    
    func getGroupID(ref: FIRDatabaseReference!, userID: String) -> String {
        
        var groupID = String()
        
        ref?.child("users").child(userID).child("groupID").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let groupIDtest = snapshot.value as? String
            
            if groupIDtest != nil {
                groupID = groupIDtest!
            } else {
                groupID = ""
            }
        })
        
        return groupID
    }
}
