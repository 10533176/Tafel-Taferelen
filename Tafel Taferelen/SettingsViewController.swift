//
//  SettingsViewController.swift
//  Tafel Taferelen
//
//  Created by Femke van Son on 19-01-17.
//  Copyright © 2017 Femke van Son. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageProfPic: UIImageView!
    var ref: FIRDatabaseReference!
    let picker = UIImagePickerController()
    var userStorage: FIRStorageReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = true
        
        ref = FIRDatabase.database().reference()
        let storage = FIRStorage.storage().reference(forURL: "gs://tafel-taferelen.appspot.com")
        
        userStorage = storage.child("users")
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        picker.delegate = self
        
        ref?.child("users").child(userID!).child("urlToImage").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let urlImage = snapshot.value as! String
            
            if let url = NSURL(string: urlImage) {
                
                if let data = NSData(contentsOf: url as URL) {
                    self.imageProfPic.image = UIImage(data: data as Data)
                }
            }
            
        })
        
        self.imageProfPic.layer.cornerRadius = self.imageProfPic.frame.size.width / 2
        self.imageProfPic.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func changeProfPic(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {

            self.imageProfPic.image = image
            saveImage()

        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func saveImage() {

        let userID = FIRAuth.auth()?.currentUser?.uid
        let changeRequest = FIRAuth.auth()!.currentUser!.profileChangeRequest()

        changeRequest.commitChanges(completion: nil)
        
        let imageRef = self.userStorage.child("\(userID).jpg")
        let data = UIImageJPEGRepresentation(self.imageProfPic.image!, 0.5)
        
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
                    self.ref.child("users").child(userID!).child("urlToImage").setValue(url.absoluteString)
                }
            })
        })
        
        uploadTask.resume()
    }
    
    
    @IBAction func loggingOUT(_ sender: Any) {
        let firebaseAuth = FIRAuth.auth()
        do {
            
            try firebaseAuth?.signOut()
            
            present( UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "logIn") as UIViewController, animated: true, completion: nil)
        
        } catch {
            self.signupErrorAlert(title: "Oops!", message: "Something went wrong while logging out. Try again later.")
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
