//
//  App+Extensions.swift
//  Calendar
//
//Test Project

import UIKit

//MARK:- Navigation bar clear
extension UINavigationBar {
    
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
    
}
//MARK:- Date extension
extension Date {
    func totalNumbersOfDaysInMonth() -> Int? {
        return Calendar.current.range(of: .day, in: .month, for: self)?.count ?? 0
    }
    func firstDateOfMonth() -> Date? {
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month, .hour], from: Calendar.current.startOfDay(for: self))
        return Calendar.current.date(from: comp)!
    }
    
    func convertDateFormater(fromFormat: DateFormatType = .simpleDateFormat) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat.rawValue
        let date = dateFormatter.string(from: self)
        dateFormatter.dateFormat = Date.DateFormatType.simpleDateFormat.rawValue
        return dateFormatter.date(from: date)

    }
    func nextDate(byDay: Int) -> Date?{
        var dateComponent = DateComponents()
        dateComponent.day = byDay
        return Calendar.current.date(byAdding: dateComponent, to: self) ?? Date()
    }
    func newMonth(byValue: Int) -> Date?{
        var dateComponent = DateComponents()
        dateComponent.month = byValue
        return Calendar.current.date(byAdding: dateComponent, to: self) ?? Date()
    }
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = DateFormatType.simpleDateFormat.rawValue
        guard let todayDate = formatter.date(from: today) else { return nil }
        let day = Calendar.current.component(.day, from: todayDate)
        return day
    }
    func toString(format: DateFormatType = .simpleDateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
    
    enum DateFormatType: String{
        case dateFormat = "yyyy-MM-dd HH:mm:ss z"
        case apiDateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        case timeDateFormat = "HH:mm"
        case simpleDateFormat = "dd-MM-yyyy"
        case weekDayFormat = "EEE"
        case yearMonthDateFormat = "yyyy-MM-dd"
        case monthFormat = "MMM yyyy"
    }
}
