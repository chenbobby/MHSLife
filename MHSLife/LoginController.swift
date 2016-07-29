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

class LoginController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate{
    
    var userId : String = ""
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var twitterLoginButton: UIView!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Google SignIn
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Twitter
        let logInButton = TWTRLogInButton(logInCompletion: {
            session, error in
            
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
                    
                    print("User logged in with Twitter" + user!.uid)
                    self.userId = user!.uid
                    
                    self.performSegueWithIdentifier("login", sender: nil)
                })
            }else{
                if(error != nil){
                    print(error!.localizedDescription)
                }
            }
        })
        
        twitterLoginButton.addSubview(logInButton)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "login"){

            self.passwordField.text = ""
            let destinationVC = segue.destinationViewController as! HomeController
            destinationVC.userUID = self.userId
        }
    }
    
    // MARK: - Email/Password
    @IBAction func loginButton(sender: AnyObject) {
        FIRAuth.auth()?.signInWithEmail(emailField.text!, password: passwordField.text!, completion: {
            (user, error) in
            
            if(error != nil){
                print(error!.localizedDescription)
                self.passwordField.text = ""
                return
            }
            
            print("User logged in" + user!.uid)
            self.userId = user!.uid
            
            self.performSegueWithIdentifier("login", sender: nil)
        })
    }
    
    // MARK: - Google
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let auth = user.authentication
        let cred = FIRGoogleAuthProvider.credentialWithIDToken(auth.idToken, accessToken: auth.accessToken)
        
        FIRAuth.auth()?.signInWithCredential(cred, completion: {
            (user, error) in
            
            if(error != nil){
                print(error?.localizedDescription)
                return
            }
            
            print("User logged in with Google" + user!.uid)
            self.userId = user!.uid
            
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
    
    
    // MARK: - Hide Navbar
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
}