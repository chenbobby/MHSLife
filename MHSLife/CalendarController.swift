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

class CalendarController: UIViewController {
    
    var userUID : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Hide Navbar
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
}
