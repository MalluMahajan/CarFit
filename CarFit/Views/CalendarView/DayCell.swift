//
//  DayCell.swift
//  Calendar
//
//  Test Project
//

import UIKit

class DayCell: UICollectionViewCell {

    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var weekday: UILabel!
    
    //MARK:- Configure selected month day cell
    var dayCellViewModel: CalendarDayCellViewModel!{
        didSet{
            self.day.text = "\(self.dayCellViewModel.day)"
            self.weekday.text = self.dayCellViewModel.weekDayName
        }
    }
    
    //MARK:- Set selected dates highlighted
    var isDateSelected: Bool!{
        didSet{
            self.dayView.backgroundColor = (isDateSelected) ? UIColor.daySelected : UIColor.clear
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dayView.layer.cornerRadius = self.dayView.frame.width / 2.0
        self.dayView.backgroundColor = .clear
    }
   
}
