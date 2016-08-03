//
//  HomeController.swift
//  MHSLife
//    /16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func logout(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        print("User logged out")
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBOutlet weak var headline1Label: UILabel!
    @IBOutlet weak var headline2Label: UILabel!
    @IBOutlet weak var headline3Label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAccount()
        loadNews()
        tableView.registerNib(UINib(nibName: "favoriteGroupCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.reloadData()
    }
    
    // MARK: - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.favorites.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! favoriteGroupCell
        
        cell.groupNameLabel?.text = User.favorites[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - Load Data
    func loadAccount() {
        let ref = FIRDatabase.database().reference()
        ref.child("users/" + User.UID).observeEventType(.Value, withBlock: {
            snapshot in
            
            if(!snapshot.exists()){
                print("No Account Exists")
                let newUser : [String : AnyObject] = ["mcclintock" : true]
                let ref = FIRDatabase.database().reference()
                ref.child("users").child(User.UID).setValue(newUser)
                print("New Account Created")
                FIRMessaging.messaging().subscribeToTopic("/topics/mcclintock")
                self.loadAccount()
            }else{
                print("Account Exists")
                User.favorites = Array((snapshot.value as! [String : AnyObject]).keys)
                print("Favorites: ")
                print(User.favorites)
            }
            self.tableView.reloadData()
        })
    }
    
    func loadNews() {
        let ref = FIRDatabase.database().reference()
        ref.child("news/").observeEventType(.Value, withBlock: {
            snapshot in
            
            let dataDict = snapshot.value as? [String : AnyObject]
            self.headline1Label.text = dataDict!["headline1"] as? String
            self.headline2Label.text = dataDict!["headline2"] as? String
            self.headline3Label.text = dataDict!["headline3"] as? String
        })
    }

}
