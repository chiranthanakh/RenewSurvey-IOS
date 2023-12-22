//
//  Extension.swift
//  LoyalInfo Loyalhospitality
//
//  Created by DREAMWORLD on 10/08/21.
//  Copyright © 2021 iMac. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices


// MARK:-
@IBDesignable
extension UIView {
    
    func addInnerShadow() {
        let innerShadow = CALayer()
        innerShadow.frame = bounds
        // Shadow path (1pt ring around bounds)
        let path = UIBezierPath(rect: innerShadow.bounds.insetBy(dx: -1, dy: -1))
        let cutout = UIBezierPath(rect: innerShadow.bounds).reversing()
        path.append(cutout)
        innerShadow.shadowPath = path.cgPath
        innerShadow.masksToBounds = true
        // Shadow properties
        innerShadow.shadowColor = UIColor(white: 0, alpha: 1).cgColor // UIColor(red: 0.71, green: 0.77, blue: 0.81, alpha: 1.0).cgColor
        innerShadow.shadowOffset = CGSize.zero
        innerShadow.shadowOpacity = 1
        innerShadow.shadowRadius = 3
        // Add
        layer.addSublayer(innerShadow)
    }
    
    func addNodataLable(strMsg: String) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        label.textAlignment = .center
        label.text = strMsg
        label.numberOfLines = 0
        
        self.addSubview(label)
    }
}

extension Float {
    func rounded(toPlaces places:Int) -> Float {
        let divisor = pow(self, Float(places))
        return (self * divisor).rounded() / divisor
    }
    
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
//MARK: - UIApplication Extension
extension UIApplication {
    
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
}

extension Date {
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
    func addDay(numnerOfDay: Int) -> Date {
        var dayComponent    = DateComponents()
        dayComponent.day    = numnerOfDay // For removing one day (yesterday): -1
        let theCalendar     = Calendar.current
        let nextDate        = theCalendar.date(byAdding: dayComponent, to: self)
        return nextDate ?? Date()
    }
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
    
    func addHour(numnerOfHour: Int) -> Date {
        var dayComponent    = DateComponents()
        dayComponent.hour    = numnerOfHour // For removing one day (yesterday): -1
        let theCalendar     = Calendar.current
        let nextDate        = theCalendar.date(byAdding: dayComponent, to: self)
        return nextDate ?? Date()
    }
    
    func localDate() -> Date {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) else {return Date()}
        
        return localDate
    }
    
    static func datesBetweenTwoDates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    var nextSaturday: Date {
        return endOfWeek ?? Date()
    }
    
    var nextSunday: Date {
        return startOfWeek ?? Date()
    }
    
    var addingOneWeek: Date {
        return Calendar.gregorian.date(byAdding: DateComponents(weekOfYear: 1), to: self)!
    }
    
    var isDateInWeekend: Bool {
        return Calendar.gregorian.isDateInWeekend(self)//.iso8601.isDateInWeekend(self)
    }
    
    var tomorrow: Date {
        return Calendar.gregorian.date(byAdding: .day, value: 1, to: noon)!
    }
    
    var noon: Date {
        return Calendar.gregorian.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    func nextFollowingSaturday(_ limit: Int) -> [Date] {
        precondition(limit > 0)
        var saturdays = [nextSaturday]
        saturdays.reserveCapacity(limit)
        return [nextSaturday] + (0..<limit-1).compactMap { _ in
            guard let next = saturdays.last?.addingOneWeek else { return nil }
            saturdays.append(next)
            return next
        }
    }
    
    func nextFollowingSunday(_ limit: Int) -> [Date] {
        precondition(limit > 0)
        var saturdays = [nextSunday]
        saturdays.reserveCapacity(limit)
        return [nextSunday] + (0..<limit-1).compactMap { _ in
            guard let next = saturdays.last?.addingOneWeek else { return nil }
            saturdays.append(next)
            return next
        }
    }
    
    func ConvertDateTo12HoursDate(formate : String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        let currenttstrdate = formatter.string(from: self)
        let currenttdate = formatter.date(from: currenttstrdate)
        return currenttdate
    }
    
    /**
     This method is used to get string of time.
     */
    func getTimeString(inFormate : String) -> String {
        
        //Conversion into 24 hours formate required in API
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inFormate
        let timeString = dateFormatter.string(from: self)
        return timeString
    }
    
    func removeTimeStampFromDate() -> Date {
        
        var dateComponents = Calendar.current.dateComponents([.year,.month,.day,.minute,.hour,.second], from: self)
        dateComponents.timeZone = TimeZone(identifier: TimeZone.current.abbreviation() ?? "GMT")
        dateComponents.minute = 0
        dateComponents.hour = 0
        dateComponents.second = 0
        
        return Calendar.current.date(from: dateComponents) ?? Date()
    }
    
    func removeTimeFromDate() -> Date {
        let stringDate = self.getFormattedString(format: "yyyy-MM-dd")
        return stringDate.getDateFromString(format: "yyyy-MM-dd")
    }
    
    func startOfMonth() -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        return  calendar.date(from: components)!

    }
    
    func endOfMonth() -> Date? {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: self.startOfMonth()!)
    }
    
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    func getDayOfWeek()->Int? {
        
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: self)
        let weekDay = myComponents.weekday
        return weekDay
    }
    
    func getCurrentYear() -> Int {
        return Calendar.current.component(.year, from: self)
    }
    
    func getDayFromDate() -> Int {
        return Calendar.current.component(.day, from: self)
    }
    
    func getMonthFromDate() -> Int {
        return Calendar.current.component(.month, from: self)
    }
    
    func getYearFromDate() -> Int {
        return Calendar.current.component(.year, from: self)
    }
    
    func getHourFromDate() -> Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    /**
     get Formatted String UTC Time Zone Date String
     - Parameter format: formatter string
     - Returns: returns date string.
     */
    func getFormattedString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = .current//
        return dateFormatter.string(from: self)
    }
    
    func getCurrentTimeZoneFormattedString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: self)
    }
    func getUTCTimeZoneFormattedString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return dateFormatter.string(from: self)
    }
    func calculateYearMonthDuration(from date: Date) -> String {
        let dc = Calendar.current.dateComponents([.year,.month], from: date, to: self)
        if dc.year == 0 {
            return "\(dc.month ?? 0) Months"
        } else {
            if dc.month == 0 {
                return "\(dc.year ?? 0) Years"
            }
            return "\(dc.year ?? 0) Years \(dc.month ?? 0) Months"
        }
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
    func getTodayWeekDayInString()-> String{
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: self)
        let weekDay = myComponents.weekday
        switch weekDay {
            case 1:
                return "S"
            case 2:
                return "M"
            case 3:
                return "T"
            case 4:
                return "W"
            case 5:
                return "T"
            case 6:
                return "F"
            case 7:
                return "S"
            default:
                return "Nada"
            }
        //return weekDay
      }

    func removeDay(numnerOfDay: Int) -> Date {
        var dayComponent    = DateComponents()
        dayComponent.day    = -(numnerOfDay) // For removing one day (yesterday): -1
        let theCalendar     = Calendar.current
        let nextDate        = theCalendar.date(byAdding: dayComponent, to: self)
        return nextDate ?? Date()
    }
    
    func removeMonth(numnerOfMonth: Int) -> Date {
        var dayComponent    = DateComponents()
        dayComponent.month    = -(numnerOfMonth) // For removing one day (yesterday): -1
        let theCalendar     = Calendar.current
        let nextDate        = theCalendar.date(byAdding: dayComponent, to: self)
        return nextDate ?? Date()
    }
    
    func numberOfDaysInCurrentMonth() -> Int {
        let dateComponents = DateComponents(year: self.getCurrentYear(), month: self.getMonthFromDate())
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        print(numDays)
        return numDays
    }
}
