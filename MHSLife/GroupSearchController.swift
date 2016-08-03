//
//  GroupSearchController.swift
//  MHSLife
//
//  Created by admin on 7/31/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class GroupSearchController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func goToHome(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    // MARK: - Properties
    var groups = [Group]()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredGroups = [Group]()
    var selectedIndexPath: NSIndexPath? = nil

    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = FIRDatabase.database().reference()
        ref.child("groups/").observeEventType(.Value, withBlock: {
            snapshot in
            
            if(!snapshot.exists()){
                print("No Groups Exists")
            }else{
                print("Loading Groups")
                let dataDict = snapshot.value as? [String : [String : AnyObject]]
                print(dataDict)
                for (group, info) in dataDict! {
                    self.groups.append(Group(name: group, description: info["description"] as! String))
                }
            }
            self.tableView.reloadData()
        })
        
        searchController.searchResultsUpdater  = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.barTintColor = UIColor(red:1.00, green:0.00, blue:0.00, alpha:1.0)
        tableView.tableHeaderView = searchController.searchBar
        tableView.registerNib(UINib(nibName: "GroupCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    // MARK: - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchController.active && searchController.searchBar.text != "") {
            return filteredGroups.count
        }
        
        return groups.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! GroupCell
        
        let group: Group
        if (searchController.active && searchController.searchBar.text != "") {
            group = filteredGroups[indexPath.row]
        }else{
            group = groups[indexPath.row]
        }
        
        // Init Cell Data
        cell.nameLabel!.text = group.name
        cell.descriptionLabel!.text = group.description
        cell.favoriteControlView.groupName = group.name
        cell.favoriteControlView.favorited = User.favorites.contains(group.name)
        if(cell.favoriteControlView.favorited == true){
            cell.favoriteControlView.button.setImage(FavoriteControl.onImage, forState: .Normal)
        }else{
            cell.favoriteControlView.button.setImage(FavoriteControl.offImage, forState: .Normal)
        }
        cell.checkHeight()
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let index = indexPath
        if(selectedIndexPath != nil) {
            if(index == selectedIndexPath) {
                return GroupCell.expandedHeight
            }else{
                return GroupCell.defaultHeight
            }
        }else{
            return GroupCell.defaultHeight
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let previousIndexPath = selectedIndexPath
        switch(selectedIndexPath) {
        case nil:
            selectedIndexPath = indexPath
        default:
            if(selectedIndexPath == indexPath) {
                selectedIndexPath = nil
            }else{
                selectedIndexPath = indexPath
            }
        }
        
        var indexPaths: Array<NSIndexPath> = []
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        if(indexPaths.count > 0){
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        }
        
    }
    
    
    //MARK: - Helper Methods
    func filterContentForSearchText(searchText: String) {
        filteredGroups = groups.filter {
            group in
            return group.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    deinit {
        searchController.view!.removeFromSuperview()
    }

}

extension GroupSearchController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
