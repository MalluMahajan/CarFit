//
//  CalendarView.swift
//  Calendar
//
//  Test Project
//

import UIKit

protocol CalendarDelegate: class {
    func getSelectedDate(_ dates: [String])
}

class CalendarView: UIView {

    @IBOutlet weak var monthAndYear: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    
    private let cellID = "DayCell"
    weak var delegate: CalendarDelegate?
    var calendarViewModel:CalendarViewModel!
    var selectedMonth: String?
    
    //MARK:- Initialize calendar
    private func initialize() {
        let nib = UINib(nibName: self.cellID, bundle: nil)
        self.daysCollectionView.register(nib, forCellWithReuseIdentifier: self.cellID)
        self.daysCollectionView.delegate = self
        self.daysCollectionView.dataSource = self
        self.calendarViewModel = CalendarViewModel()
        self.setSelectedMonth()
        self.moveToCurrentDay()
    }
    
    //MARK:- Change month when left and right arrow button tapped
    @IBAction func arrowTapped(_ sender: UIButton) {
        self.calendarViewModel.actionChangeMonth(byValue: (sender.tag == 0 ? -1 : 1), completionHandler: { (isMonthSelected) -> Void in
            self.daysCollectionView.reloadData()
            self.setSelectedMonth()
            if isMonthSelected {
                self.moveToCurrentDay()
            } else {
                self.daysCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
            }
            
        })
    }
    //MARK:- Scroll to current selected date
    func moveToCurrentDay(){
        let day = Date().getDayOfWeek(Date().toString(format: .simpleDateFormat)) ?? 0
        self.daysCollectionView.scrollToItem(at: IndexPath(row: day, section: 0), at: .right, animated: true)
    }
    
    //MARK:- Set selected date month title in calendar view
    func setSelectedMonth(){
        self.monthAndYear.text = self.calendarViewModel.firstDateOfSelectedMonth.toString(format: .monthFormat)
    }
}

//MARK:- Calendar collection view delegate and datasource methods
extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.calendarViewModel.numberOfDays
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID, for: indexPath) as! DayCell
        cell.dayCellViewModel = CalendarDayCellViewModel(date: calendarViewModel.getNextDate(byDay: indexPath.row))
        if self.calendarViewModel.arraySelectedDates.contains(cell.dayCellViewModel.dayCellSelectedDateString){
            cell.isDateSelected = true
        }else{
            cell.isDateSelected = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? DayCell{
            self.calendarViewModel.actionDateSelected(isSelected: cell.isDateSelected, selectedDate: cell.dayCellViewModel.dayCellSelectedDateString)
            self.delegate?.getSelectedDate(self.calendarViewModel?.arraySelectedDates ?? [])
            self.daysCollectionView.reloadData()
        }
    }
}

//MARK:- Add calendar to the view
extension CalendarView {
    
    public class func addCalendar(_ superView: UIView) -> CalendarView? {
        var calendarView: CalendarView?
        if calendarView == nil {
            calendarView = UINib(nibName: "CalendarView", bundle: nil).instantiate(withOwner: self, options: nil).last as? CalendarView
            guard let calenderView = calendarView else { return nil }
            calendarView?.frame = CGRect(x: 0, y: 0, width: superView.bounds.size.width, height: superView.bounds.size.height)
            superView.addSubview(calenderView)
            calenderView.initialize()
            return calenderView
        }
        return nil
    }
    
}
