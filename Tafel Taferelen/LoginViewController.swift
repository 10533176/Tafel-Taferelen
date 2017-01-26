//
//  ViewController.swift
//  Tafel Taferelen
//
//  Created by Femke van Son on 10-01-17.
//  Copyright © 2017 Femke van Son. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        guard emailField.text != "", pwField.text != "" else {return}
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: pwField.text!, completion: {(user, error) in
            
            if let error = error {
                self.signupErrorAlert(title: "Oops!", message: error.localizedDescription)
            }
            
            if user != nil {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVC")
                self.present(vc, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func resettingPassword(_ sender: Any) {
        if emailField.text != "" {
            resetPassword(email: emailField.text!)
        } else {
            self.signupErrorAlert(title: "Oops!", message: "Fill in your email adress to reset your password.")
        }
        
    }
    func resetPassword(email: String) {
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: {(error) in
            if error == nil {
                self.signupErrorAlert(title: "Succeeded!", message: "An email with information on how to reset your password has been send to you.")
            } else {
                self.signupErrorAlert(title: "Oops!", message: (error?.localizedDescription)!)
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

