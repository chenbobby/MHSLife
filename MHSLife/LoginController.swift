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
//            let destinationTBC = segue.destinationViewController as! UITabBarController
//            let destinationVC1 = destinationTBC.viewControllers![0] as! HomeController
//            let destinationVC2 = destinationTBC.viewControllers![1] as! CalendarController
//            destinationVC1.userUID = User.UID
//            destinationVC2.userUID = User.UID
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
            
            User.UID = user!.uid
            print("User logged in with Email: " + User.UID)
            
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
            
            User.UID = user!.uid
            print("User logged in with Google: " + User.UID)
            
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
        twitterButton = TWTRLogInButton(logInCompletion: {
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
                    
                    User.UID = user!.uid
                    print("User logged in with Twitter: " + User.UID)
                    
                    self.performSegueWithIdentifier("login", sender: nil)
                })
            }else{
                if(error != nil){
                    print(error!.localizedDescription)
                }
            }
        })
        
    }
    
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