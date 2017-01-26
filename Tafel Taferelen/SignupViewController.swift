//
//  SignupViewController.swift
//  Tafel Taferelen
//
//  Created by Femke van Son on 10-01-17.
//  Copyright © 2017 Femke van Son. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confPwField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var headBtn: UIButton!
    @IBOutlet weak var pictureBtn: UIButton!
    
    let picker = UIImagePickerController()
    var userStorage: FIRStorageReference!
    var ref: FIRDatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        
        self.initializeCloseKeyboardTap()
        
        let storage = FIRStorage.storage().reference(forURL: "gs://tafel-taferelen.appspot.com")
        
        ref = FIRDatabase.database().reference()
        
        userStorage = storage.child("users")
        
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2
        self.imageView.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeCloseKeyboardTap() {
        
        NotificationCenter.default.addObserver(self, selector: Selector(("onKeyboardOpen:")), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: Selector(("onKeyboardClose:")), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector(("handleOnTapAnywhereButKeyboard:")))
        tapRecognizer.delegate = self //delegate event notifications to this class
        self.view.addGestureRecognizer(tapRecognizer)
        
    }
    
    
    func onKeyboardClose(notification: NSNotification) {
        print ("keyboardClosed")
    }
    
    func onKeyboardOpen(notification: NSNotification) {
        print ("keyboardOpen")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func selectImagePressed(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            headBtn.isHidden = true
            self.imageView.image = image
            nextBtn.isHidden = false
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    

    @IBAction func nextPressed(_ sender: Any) {
        
        guard nameField.text != "", emailField.text != "", passwordField.text != "", confPwField.text != "" else { return }
        
        if passwordField.text == confPwField.text {
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                    self.signupErrorAlert(title: "Oops!", message: "Er ging iets mis! \(error.localizedDescription)")
                }
                
                if let user = user {
                    
                    let changeRequest = FIRAuth.auth()!.currentUser!.profileChangeRequest()
                    changeRequest.displayName = self.nameField.text!
                    changeRequest.commitChanges(completion: nil)
                    
                    let imageRef = self.userStorage.child("\(user.uid).jpg")
                    let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
                    
                    let uploadTask = imageRef.put(data!, metadata: nil, completion: { (metadata, err) in
                        if err != nil {
                            print("bloebloebloe")
                            print (err!.localizedDescription)
                            self.signupErrorAlert(title: "Oops!", message: err!.localizedDescription)
                            
                        }
                        
                        imageRef.downloadURL(completion: {(url, er) in
                            if er != nil {
                                print(er!.localizedDescription)
                                self.signupErrorAlert(title: "Oops!", message: er!.localizedDescription)
                            }
                            
                            if let url = url {
                                let userInfo: [String : Any] = ["uid" : user.uid,
                                                                "full name" : self.nameField.text!,
                                                                "email" : self.emailField.text!,
                                                                "urlToImage" : url.absoluteString]
                                self.ref.child("users").child(user.uid).setValue(userInfo)
                                
                                
                                self.ref.child("emailDB").child(user.uid).setValue(self.emailField.text!)
                                

                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVC")
                                
                                self.present(vc, animated: true, completion: nil)
                                print ("loopt die doorheen")
                            }
            
                        })
                    })
                    
                    uploadTask.resume()
            }
        })
            
        } else {
            self.signupErrorAlert(title: "Oops!", message: "The passwords do not match")
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
