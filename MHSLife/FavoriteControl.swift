//
//  FavoriteControl.swift
//  MHSLife
//
//  Created by admin on 7/31/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FavoriteControl: UIView {
    
    var favorited: Bool!
    var groupName: String!
    var button: UIButton!
    static var onImage: UIImage = UIImage(named: "Star Filled-25")!
    static var offImage: UIImage = UIImage(named: "Star-25")!
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        button.addTarget(self, action: #selector(FavoriteControl.toggleFavorite(_:)), forControlEvents: .TouchDown)
        addSubview(button)
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: 35, height: 35)
    }
    
    func toggleFavorite(button: UIButton) {
        User.toggleSubscription(self.groupName)
        self.favorited = !self.favorited
        self.setImage()
    }
    
    func setImage() {
        if(self.favorited == true){
            self.button.setImage(FavoriteControl.onImage, forState: .Normal)
        }else{
            self.button.setImage(FavoriteControl.offImage, forState: .Normal)
        }
    }

}
