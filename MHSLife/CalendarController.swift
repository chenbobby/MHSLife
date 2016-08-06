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

class CalendarController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Calendar View Did Load")
    }

}

extension CalendarController: FSCalendarDelegate, FSCalendarDataSource {
    
}