//
//  CalendarController.swift
//  MHSLife
//
//  Created by admin on 7/31/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FSCalendar
import SVProgressHUD

class CalendarController: UIViewController {
    
    let dateFormatter = NSDateFormatter()
    let calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
    var events = [Event]()
    var viewableEvents = [Event]()
    var dayEvents = [Event]()
    
    @IBOutlet weak var fscalendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        print("Calendar View Did Load")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadEvents()
    }
    
    // MARK: - Load Data
    func loadEvents() {
        User.favoriteEvents = []
        self.events = []
        self.viewableEvents = []
        self.dayEvents = []
        
        SVProgressHUD.showWithStatus("Loading Events")
        
        let ref = FIRDatabase.database().reference()
        ref.child("events").observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            
            if(!snapshot.exists()){
                print("No Events Exist")
                SVProgressHUD.showErrorWithStatus("Failed to Connect")
                return
            }else{
                let dataDict = snapshot.value as? [String : [String : AnyObject]]
                for (event, info) in dataDict! {
                    self.events.append(Event(
                        exclusive: info["exclusive"] as! Bool,
                        group: info["group"] as! String,
                        name: event,
                        date: info["date"] as! String,
                        location: info["location"] as! String,
                        description: info["description"] as! String
                    ))
                }
                
            }
            
            for event in self.events {
                if User.favorites.contains(event.group) {
                    User.favoriteEvents.append(event)
                    self.viewableEvents.append(event)
                    continue
                } else if !event.exclusive {
                    self.viewableEvents.append(event)
                }
            }
            
            self.fscalendar.reloadData()
            SVProgressHUD.dismiss()
        })
    }

}

extension CalendarController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendarCurrentPageDidChange(calendar: FSCalendar) {
        print(calendar.currentPage)
    }
    
    func calendar(calendar: FSCalendar, numberOfEventsForDate date: NSDate) -> Int {
        var events = 0
        for event in User.favoriteEvents{
            let eventDate = dateFormatter.dateFromString(event.date)
            if(self.calendar!.compareDate(date, toDate: eventDate!, toUnitGranularity: .Day) == .OrderedSame){
                events += 1;
            }
        }
        return events
    }
    
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        self.dayEvents = []
        for event in self.viewableEvents{
            let eventDate = dateFormatter.dateFromString(event.date)
            if(self.calendar!.compareDate(date, toDate: eventDate!, toUnitGranularity: .Day) == .OrderedSame){
                self.dayEvents.append(event)
            }
        }
        
        self.tableView.reloadData()
    }
    
    
    
}

extension CalendarController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var sections: Int = 0
        if(self.dayEvents.count != 0){
            self.tableView.separatorStyle = .SingleLine
            sections = 1
            self.tableView.backgroundView = nil
        }else{
            let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
            noDataLabel.font = UIFont(name: "KGMissKindyChunky", size: 20)
            noDataLabel.text = "Find Some Events"
            noDataLabel.textColor = UIColor.blackColor()
            noDataLabel.textAlignment = .Center
            self.tableView.backgroundView = noDataLabel
            self.tableView.separatorStyle = .None
        }
        return sections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dayEvents.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.text = self.dayEvents[indexPath.row].name
        cell.textLabel!.font = UIFont(name: "KGMissKindyChunky", size: 18)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("EventPopUpID") as! EventController
        popOverVC.event = self.dayEvents[indexPath.row]
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMoveToParentViewController(self)
        
        self.tableView.reloadData()
        
    }
}