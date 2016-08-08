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
import SVProgressHUD

class RegisterController: UIViewController {
    
    
    @IBAction func goToLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBAction func registerButton(sender: AnyObject) {
        
        let error = validate()
        if(error != ""){
            errorLabel.text = error
        }else{
            SVProgressHUD.showWithStatus("Creating Account...")
            FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: newPasswordField.text!, completion: {
                (user, error) in
            
                if error != nil {
                    print(error!.localizedDescription)
                    SVProgressHUD.showErrorWithStatus("Failed to Connect")
                    return
                } else {
                    let newUser : [String : AnyObject] = ["favorites" : []]
                    let ref = FIRDatabase.database().reference()
                    ref.child("users").child(user!.uid).setValue(newUser)
                    SVProgressHUD.showSuccessWithStatus("Account Created")
                    
                    self.errorLabel.text = ""
                    self.emailField.text = ""
                    self.newPasswordField.text = ""
                    self.confirmPasswordField.text = ""
                
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
    }
    
    func validate() -> String {
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