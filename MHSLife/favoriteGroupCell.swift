//
//  favoriteGroupCell.swift
//  MHSLife
//
//  Created by admin on 8/2/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

class favoriteGroupCell: UITableViewCell {
    
    var delegate: HomeController?
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBAction func unfavoriteGroup(sender: AnyObject) {
        let alertController = UIAlertController(title: self.groupNameLabel.text, message:
            "You will no longer receive notifications from this group.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        delegate!.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
