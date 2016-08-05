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
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var sections: Int = 0
        if(User.favorites.count != 0){
            self.tableView.separatorStyle = .SingleLine
            sections = 1
            self.tableView.backgroundView = nil
        }else{
            let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
            noDataLabel.font = UIFont(name: "Avenir Next Condensed", size: 20)
            noDataLabel.text = "Add Favorites for Event Notifications"
            noDataLabel.textColor = UIColor.blackColor()
            noDataLabel.textAlignment = .Center
            self.tableView.backgroundView = noDataLabel
            self.tableView.separatorStyle = .None
        }
        return sections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.favorites.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel!.text = User.favorites[indexPath.row]
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.unfavorite(_:)))
        cell.addGestureRecognizer(longPressGestureRecognizer)
        

        
        return cell
    }
    
    func unfavorite(sender: UILongPressGestureRecognizer) {
        if(sender.state == .Began){
            let longPressLocation = sender.locationInView(self.tableView)
            let indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(longPressLocation)!
            let cell = self.tableView.cellForRowAtIndexPath(indexPath)
            let groupName = cell!.textLabel!.text
            let alert = UIAlertController(title: "Woah there...", message: "Are you sure you want to unfavorite " + groupName! + "?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Yeah, Pretty Sure", style: UIAlertActionStyle.Destructive, handler: {
                action in
                
                User.toggleSubscription(groupName!)
            }))
            alert.addAction(UIAlertAction(title: "Not that Sure", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
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
                User.favorites = User.removeDefault(Array((snapshot.value as! [String : AnyObject]).keys))
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
