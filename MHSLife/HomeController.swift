//
//  HomeController.swift
//  MHSLife
//    /16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class HomeController: UIViewController{
    
    var favorites: [String] = []
    
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
        SVProgressHUD.showWithStatus("Loading Account")
        let ref = FIRDatabase.database().reference()
        ref.child("users/" + User.UID).observeEventType(.Value, withBlock: {
            snapshot in
            
            if(!snapshot.exists()){
                let newUser : [String : AnyObject] = ["mcclintock" : true]
                let ref = FIRDatabase.database().reference()
                ref.child("users").child(User.UID).setValue(newUser)
                FIRMessaging.messaging().subscribeToTopic("/topics/mcclintock")
                self.loadAccount()
            }else{
                User.favorites = Array((snapshot.value as! [String : AnyObject]).keys)
                self.favorites = User.removeDefault()
            }
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        })
    }
    
    func loadNews() {
        SVProgressHUD.showWithStatus("Loading News")
        let ref = FIRDatabase.database().reference()
        ref.child("news/").observeEventType(.Value, withBlock: {
            snapshot in
            
            let dataDict = snapshot.value as? [String : AnyObject]
            self.headline1Label.text = dataDict!["headline1"] as? String
            self.headline2Label.text = dataDict!["headline2"] as? String
            self.headline3Label.text = dataDict!["headline3"] as? String
            SVProgressHUD.dismiss()
        })
    }

}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var sections: Int = 0
        if(self.favorites.count != 0){
            self.tableView.separatorStyle = .SingleLine
            sections = 1
            self.tableView.backgroundView = nil
        }else{
            let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
            noDataLabel.font = UIFont(name: "KGMissKindyChunky", size: 18)
            noDataLabel.text = "Oh-No! No Favorites!"
            noDataLabel.textColor = UIColor.blackColor()
            noDataLabel.textAlignment = .Center
            self.tableView.backgroundView = noDataLabel
            self.tableView.separatorStyle = .None
        }
        return sections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favorites.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel!.text = self.favorites[indexPath.row]
        cell.textLabel!.font = UIFont(name: "KGMissKindyChunky", size: 18)
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.unfavorite(_:)))
        cell.addGestureRecognizer(longPressGestureRecognizer)
        
        return cell
    }
}
