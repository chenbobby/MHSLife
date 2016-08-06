//
//  DayCellView.swift
//  MHSLife
//
//  Created by admin on 8/5/16.
//  Copyright © 2016 admin. All rights reserved.
//

import JTAppleCalendar

class DayCellView: JTAppleDayCellView {
    
    
    @IBOutlet var dayLabel: UILabel!
    
    var normalDayColor = UIColor(colorWithHexValue: 0xFFFCFC)
    var selectedDayColor = UIColor(colorWithHexValue: 0xFF0000)
    var weekendDayColor = UIColor(colorWithHexValue: 0x966868)
    
    func setupCellBeforeDisplay(cellState: CellState, date: NSDate) {
        dayLabel.text = cellState.text
        configureTextColor(cellState)
    }
    
    func configureTextColor(cellState: CellState) {
        if(cellState.isSelected){
            dayLabel.textColor = selectedDayColor
        }else if(cellState.dateBelongsTo == .ThisMonth){
            dayLabel.textColor = normalDayColor
        }else{
            dayLabel.textColor = weekendDayColor
        }
    }
    
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}