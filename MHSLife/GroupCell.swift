//
//  GroupCell.swift
//  MHSLife
//
//  Created by admin on 7/31/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    class var defaultHeight: CGFloat { get { return 47 } }
    class var expandedHeight: CGFloat { get { return 75 } }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func checkHeight() {
        descriptionLabel.hidden = (frame.size.height < GroupCell.expandedHeight)
    }
}
