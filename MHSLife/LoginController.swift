//
//  LoginController.swift
//  MHSLife
//
//  Created by admin on 7/24/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginController: UIViewController {

    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginButton(sender: AnyObject) {
        FIRAuth.auth()?.signInWithEmail(emailField.text!, password: passwordField.text!, completion: {
            (user, error) in
            
            if error != nil{
                print(error!.localizedDescription)
            } else {
            print("User logged in")
            }
        })
    }

}