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
import GoogleSignIn
import TwitterKit
import SVProgressHUD

class LoginController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate{
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var twitterButton: TWTRLogInButton!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Google SignIn
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Twitter
        setupTwitterButton()
        

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "login"){
            self.passwordField.text = ""
            // TODO: Setup Activity Indicator
        }
    }
    
    // MARK: - Email/Password
    @IBAction func loginButton(sender: AnyObject) {
        SVProgressHUD.show()
        
        FIRAuth.auth()?.signInWithEmail(emailField.text!, password: passwordField.text!, completion: {
            (user, error) in
            
            if(error != nil){
                SVProgressHUD.showErrorWithStatus("Failed to Connect")
                print(error!.localizedDescription)
                if self.emailField.text == "" {
                    self.loadAlert("Email")
                } else if self.passwordField.text == "" {
                    self.loadAlert("Password")
                } else {
                    self.loadAlert("Other")
                }
                self.passwordField.text = ""
                return
            }
            
            User.UID = user!.uid
            
            SVProgressHUD.dismiss()
            
            self.performSegueWithIdentifier("login", sender: nil)
        })
    }
    
    // MARK: - Google
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        SVProgressHUD.show()
        
        if let error = error {
            print(error.localizedDescription)
            SVProgressHUD.showErrorWithStatus("Failed to Connect")
            return
        }
        
        let auth = user.authentication
        let cred = FIRGoogleAuthProvider.credentialWithIDToken(auth.idToken, accessToken: auth.accessToken)
        
        FIRAuth.auth()?.signInWithCredential(cred, completion: {
            (user, error) in
            
            if(error != nil){
                SVProgressHUD.showErrorWithStatus("Failed to Connect")
                print(error?.localizedDescription)
                return
            }
            
            User.UID = user!.uid
            
            SVProgressHUD.dismiss()
            
            self.performSegueWithIdentifier("login", sender: nil)
        })
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        try! FIRAuth.auth()!.signOut()
    }
    
    // MARK: - Twitter
    func setupTwitterButton() {
        self.twitterButton.logInCompletion = {
            (session, error) in
            
            SVProgressHUD.show()
            
            if(session != nil){
                let authToken = session?.authToken
                let authTokenSecret = session?.authTokenSecret
                
                let cred = FIRTwitterAuthProvider.credentialWithToken(authToken!, secret: authTokenSecret!)
                FIRAuth.auth()?.signInWithCredential(cred, completion: {
                    (user, error) in
                    
                    if(error != nil){
                        print(error!.localizedDescription)
                        return
                    }
                    
                    User.UID = user!.uid
                    
                    SVProgressHUD.dismiss()
                    
                    self.performSegueWithIdentifier("login", sender: nil)
                })
            }else{
                SVProgressHUD.showErrorWithStatus("Failed to Connect...")
                if(error != nil){
                    print(error!.localizedDescription)
                }
            }
        }
    }
    
    // Alert
    func loadAlert(error: String) {
        var message: String
        switch(error){
        case "Email":
            message = "Please Enter Email"
        case "Password":
            message = "Please Enter Password"
        case "Other":
            message = "Something's wrong with your input"
        default:
            message = "Unknown Login Error"
        }
        
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // Credits
    @IBAction func showCredits(sender: UILongPressGestureRecognizer) {
        if(sender.state == .Began){
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CreditsPopUpID") as! CreditsController
            self.addChildViewController(popOverVC)
            popOverVC.view.frame = self.view.frame
            self.view.addSubview(popOverVC.view)
            popOverVC.didMoveToParentViewController(self)
        }
    }
}