//
//  EventController.swift
//  MHSLife
//
//  Created by admin on 8/7/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

class EventController: UIViewController {
    
    var event: Event?
    let formatter = NSDateFormatter()
    let dayFormatter = NSDateFormatter()
    let timeFormatter = NSDateFormatter()
    let calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
    
    @IBAction func closePopUp(sender: AnyObject) {
        self.removeAnimate()
    }
    
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        dayFormatter.dateFormat = "EEE MMM dd"
        timeFormatter.dateFormat = "HH:mm"
        let date = formatter.dateFromString(self.event!.date)
        let day = dayFormatter.stringFromDate(date!)
        let time = timeFormatter.stringFromDate(date!)
        
        self.groupLabel.text = (self.event!.group == "mcclintock") ? "McClintock" : self.event!.group
        self.nameLabel.text = self.event!.name
        self.locationLabel.text = self.event!.location
        self.dateLabel.text = day
        self.timeLabel.text = (time == "00:00") ? "" : time
        self.descriptionLabel.text = self.event!.description
        
        self.showAnimate()
        
        print(self.event)
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        })
    }
    
    func removeAnimate() {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0
            }, completion: {
                (finished: Bool) in
                if finished {
                    self.view.removeFromSuperview()
                }
        })
    }
    
}
