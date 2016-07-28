//
//  RegisterController.swift
//  MHSLife
//
//  Created by admin on 7/26/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class RegisterController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBAction func registerButton(sender: AnyObject) {
        
        let error = validate()
        if(error != ""){
            errorLabel.text = error
        }else{
            errorLabel.text = "Creating Account..."
            FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: newPasswordField.text!, completion: {
                (user, error) in
            
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    print("User created...")
                    let newUser : [String : AnyObject] = ["name" : self.nameField.text!, "favorites" : []]
                    let ref = FIRDatabase.database().reference()
                    ref.child("users").child(user!.uid).setValue(newUser)
                
                    self.navigationController?.popViewControllerAnimated(true)
                }
            })
        }
    }
    
    func validate() -> String {
        if(nameField.text == ""){
            return "Please Enter Name"
        }
        if(emailField.text == ""){
            return "Please Enter Email"
        }
        if(newPasswordField.text == ""){
            return "Please Enter New Password"
        }
        if(confirmPasswordField.text == ""){
            return "Please Confirm Password"
        }
        if(newPasswordField.text != confirmPasswordField.text){
            return "Passwords Do Not Match"
        }
        return ""
    }

}