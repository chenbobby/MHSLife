//
//  RegisterController.swift
//  MHSLife
//
//  Created by admin on 7/26/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBAction func registerButton(sender: AnyObject) {
        FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: newPasswordField.text!, completion: {
            (user, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("User created...")
            }
        })
    }

}