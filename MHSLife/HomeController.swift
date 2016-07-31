//
//  HomeController.swift
//  MHSLife
//
//  Created by admin on 7/28/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeController: UIViewController {
    
    var userUID : String!
    var user : User!
    
    @IBAction func logout(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        print("User logged out")
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    @IBOutlet weak var helloLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var dataDict : [String : AnyObject] = [:]
        let ref = FIRDatabase.database().reference()
        ref.child("users/" + self.userUID).observeEventType(.Value, withBlock: {
            snapshot in
            
            if(!snapshot.exists()){
                print("No data received")
            }else{
                dataDict = snapshot.value as! [String : AnyObject]
            }
            self.user = User(name: (dataDict["name"] != nil) ? dataDict["name"] as! String : "Charger", favorites: (dataDict["favorites"] != nil) ? dataDict["favorites"] as! [String] : [])
            print(self.user)
            self.helloLabel.text = "Hello " + self.user.name
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
