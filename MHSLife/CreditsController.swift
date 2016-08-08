//
//  CreditsController.swift
//  MHSLife
//
//  Created by admin on 8/7/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

class CreditsController: UIViewController {

    @IBAction func closePopUp(sender: AnyObject) {
        self.removeAnimate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimate()
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
