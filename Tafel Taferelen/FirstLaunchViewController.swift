//
//  FirstLaunchViewController.swift
//  Tafel Taferelen
//
//  Created by Femke van Son on 24-01-17.
//  Copyright © 2017 Femke van Son. All rights reserved.
//

import UIKit
import Firebase

class FirstLaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appLaunchedBefore = isAppAlreadyLaunchedOnce()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
        
            if appLaunchedBefore == true {
                FIRAuth.auth()?.addStateDidChangeListener { auth, user in
                    if user != nil {
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVC")
                        self.present(vc, animated: true, completion: nil)
                    } else {
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "logIn")
                        self.present(vc, animated: true, completion: nil)
                    }
                }

            } else {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "introPage")
                self.present(vc, animated: true, completion: nil)
            }
        })
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil{

            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
