//
//  SignupViewController.swift
//  Tafel Taferelen
//
//  Created by Femke van Son on 10-01-17.
//  Copyright © 2017 Femke van Son. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
                            print("bloebloebloe")
                            
                        }
                        
                        imageRef.downloadURL(completion: {(url, er) in
                            if er != nil {
                                print(er!.localizedDescription)
                                print("hoihoi")
                            }
                            
                            if let url = url {
                                let userInfo: [String : Any] = ["uid" : user.uid,
                                                                "full name" : self.nameField.text!,
                                                                "urlToImage" : url.absoluteString]
                                self.ref.child("users").child(user.uid).setValue(userInfo)
                                
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
            print("password does not match")
        }
    }

}
