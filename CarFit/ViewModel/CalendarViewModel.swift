//
//  CalendarViewModel.swift
//  CarFit
//
//  Created by Mallu on 19/12/20.
//  Copyright © 2020 Test Project. All rights reserved.
//

import UIKit

class CalendarViewModel: NSObject {
    
    var arraySelectedDates = [String]()
    var firstDateOfSelectedMonth = Date()
    typealias CompletionHandler = (_ isMonthSelected:Bool) -> Void
    
    override init() {
        super.init()
        self.arraySelectedDates = [Date().toString(format: .simpleDateFormat)]
        self.firstDateOfSelectedMonth = self.getFirstDate(date: Date())
    }
    var numberOfDays: Int {
        return firstDateOfSelectedMonth.totalNumbersOfDaysInMonth() ?? 0
    }
    func getFirstDate(date: Date)->Date{
        return date.firstDateOfMonth() ?? Date()
    }
    func getNextDate(byDay: Int) -> Date{
        return firstDateOfSelectedMonth.nextDate(byDay: byDay) ?? Date()
    }
    //MARK:- Change calendar month with next or previous arrow
    func actionChangeMonth(byValue: Int, completionHandler: CompletionHandler){
        self.firstDateOfSelectedMonth = self.firstDateOfSelectedMonth.newMonth(byValue: byValue) ?? Date()
        var isCurrentMonth = false // true if current month
        if self.firstDateOfSelectedMonth.toString(format: .monthFormat) == Date().toString(format: .monthFormat){
            isCurrentMonth = true
        }
        completionHandler(isCurrentMonth)
    }
    //MARK:- Select/Deselect date in calendar
    func actionDateSelected(isSelected: Bool, selectedDate: String){
        if isSelected{
            if let indexPath = self.arraySelectedDates.firstIndex(of: selectedDate){
                self.arraySelectedDates.remove(at: indexPath)
            }
        }else{
           self.arraySelectedDates.append(selectedDate)
        }
    }
}
class CalendarDayCellViewModel: NSObject {
    private let myCalendar = Calendar.current
    var calendarDate: Date!
    
    init(date: Date) {
        self.calendarDate = date
    }
    
    var day: Int{
        return self.myCalendar.component(.day, from: self.calendarDate)
    }
    
    var weekDayName: String{
        return self.calendarDate.toString(format: Date.DateFormatType.weekDayFormat)
    }
    //MARK:- Get date of selected date
    var dayCellSelectedDateString: String{
        return calendarDate.toString(format: .simpleDateFormat)
    }
    
}
