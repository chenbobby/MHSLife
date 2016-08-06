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
import JTAppleCalendar

class CalendarController: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthYearLabel: UILabel!
    
    let testCalendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    let formatter = NSDateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendarView.dataSource = self
        self.calendarView.delegate = self
        self.calendarView.registerCellViewXib(fileName: "DayCellView")
        calendarView.cellInset = CGPoint(x: 1, y: 1)
        //calendarView.itemSize = 46
        calendarView.reloadData()

        print("Calendar View Did Load")
    }
    
    
    @IBAction func next(sender: AnyObject) {
        self.calendarView.scrollToNextSegment()
    }
    
    @IBAction func previous(sender: AnyObject) {
        self.calendarView.scrollToPreviousSegment()
    }

}

extension CalendarController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    
    // Required
    func configureCalendar(calendar: JTAppleCalendarView) -> (startDate: NSDate, endDate: NSDate, numberOfRows: Int, calendar: NSCalendar) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyy MM dd"
        
        let firstDate = formatter.dateFromString("2016 01 01")
        let secondDate = NSDate()
        let numberOfRows = 6
        let aCalendar = NSCalendar.currentCalendar() // Configure Calendar to Timezone
        
        return (startDate: firstDate!, endDate: secondDate, numberOfRows: numberOfRows, calendar: aCalendar)
    }
    
    func calendar(calendar: JTAppleCalendarView, isAboutToDisplayCell cell: JTAppleDayCellView, date: NSDate, cellState: CellState) {
        (cell as! DayCellView).setupCellBeforeDisplay(cellState, date: date)
    }
    
}