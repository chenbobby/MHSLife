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
        ref.child("users/" + User.UID).observeEventType(.Value, withBlock: {
            snapshot in
            
            if(!snapshot.exists()){
                print("No data received")
            }else{
                dataDict = snapshot.value as! [String : AnyObject]
            }

            User.name = (dataDict["name"] != nil) ? dataDict["name"] as! String : "Charger"
            User.favorites = (dataDict["favorites"] != nil) ? dataDict["favorites"] as! [String] : []
            self.helloLabel.text = "Hello " + User.name
        })
        
    }

}
